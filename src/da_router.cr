
{% system("#{__DIR__}/../bin/da_router.writer reset") %}
require "http"

module DA_ROUTER

  macro included
    getter ctx : HTTP::Server::Context
    def initialize(@ctx)
    end # === def initialize
  end

  extend self

  def is_match?(path : Array(String), target)
    return false unless path.size == target.size
    target.each_with_index { |piece, i|
      case piece
      when String
        return false unless path[i]? == piece
      when Symbol
        piece
      else
        raise Exception.new("Unknown type for match: #{piece.inspect}")
      end
    }
    true
  end # === def self.is_match?

  macro route(ctx)
    crumbs__ = nil
    ctx__ = {{ctx}}
    {{yield}}
    crumbs__ = nil
    ctx__ = nil
  end # === macro route

  macro path_to_tuple(path)
    {% pieces = path.split("/").reject { |x| x.empty? }.map { |x| x[0..0] == ":" ? x.id : x.stringify } %}
    { {{pieces.join(", ").id}} }
  end # === macro to_tuple

  {% for m in %w(head get post put patch delete options) %}
    macro {{m.id}}(path, &blok)
      route({{m}}, \{{path}}, \{{@type.name}}) do
        \{{blok.body}}
      end
    end
  {% end %}

  macro route(http_method, path, klass, &blok)
    {% meth = "#{http_method.id}#{path.downcase.gsub(/[^a-z0-9\_]/, "_").id}".id %}
    {% system("#{__DIR__}/../bin/da_router.writer new_route #{http_method.id} #{path.id} #{klass.id} :#{meth.id}") %}
    {% arg_names = path.split("/").select { |x| x =~ /^:/ }.map { |x| x.gsub(/^\:/, "").id }.join(", ").id %}
    def {{meth.id}}({{arg_names}})
      {{blok.body}}
    end

  end # === macro match

  macro _get(path, &blok)
    {% puts "from macro get: #{__FILE__}" %}
    {% puts "from macro get: #{__DIR__}" %}
    {% meth_name = "get#{path.downcase.gsub(/[^a-z0-9\_]/, "_").id}".id %}
    {% arg_names = path.split("/").select { |x| x =~ /^:/ }.map { |x| x.gsub(/^\:/, "").id }.join(", ").id %}

    {% puts system("#{__DIR__}/../../out/writer new_path get #{path.id}, #{@type.name}, :#{meth_name}").stringify %}
    def {{meth_name}}({{arg_names}})
      {{blok.body}}
    end
  end # === macro get

  macro route!(ctx)
    crumbs__ = nil
    ctx__ = {{ctx}}
    {% for line in system("#{__DIR__}/../bin/da_router.writer get_code").split("\n") %}
      {% if !line.strip.empty? %}
        {% line = line.split %}
        {% http_method = line.first %}
        {% path = line[1] %}
        {% klass = line[2].id %}
        {% meth = line.last.gsub(/^\:/, "") %}
        {% if path == "/" %}
          if ctx__.request.path == "/" && ctx__.request.method == "{{http_method.upcase.id}}"
            return {{klass}}.new(ctx__).{{meth.id}}
          end
        {% else %}
          crumbs__ = crumbs__ || (ctx__.request.path).split("/").reject { |s| s.empty? }
          if DA_ROUTER.is_match?(crumbs__, path_to_tuple({{path}})) && ctx__.request.method == "{{http_method.upcase.id}}"
            return {{klass}}.new(ctx__).{{meth.id}}(
              {%
               positions = [] of StringLiteral
               i = -1
               path.split("/").reject { |s| s.empty? }.map { |s|
                 i = i + 1
                 if s[0..0] == ":"
                   positions.push("crumbs__[" + i.stringify + "]")
                 else
                   nil
                 end
               }.reject { |v| !v }
               %}
              {{positions.join(", ").id}}
            )
          end
        {% end %}
      {% end %}
    {% end %}
    {% system("#{__DIR__}/../bin/da_router.writer reset") %}
  end # === macro routes!

end # === module DA_ROUTER

