

module DA_ROUTER

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

  macro route(http_method, path, klass, meth)
    {% if path == "/" %}
      if ctx__.request.path == "/" && ctx__.request.method == "{{http_method.upcase.id}}"
        return {{klass}}.new(ctx__).{{http_method.downcase.id}}_{{meth.id}}
      end
    {% else %}
      crumbs__ = crumbs__ || (ctx__.request.path).split("/").reject { |s| s.empty? }
      if DA_ROUTER.is_match?(crumbs__, path_to_tuple({{path}})) && ctx__.request.method == "{{http_method.upcase.id}}"
        return {{klass}}.new(ctx__).{{http_method.downcase.id}}_{{meth.id}}(
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
  end # === macro match

  {% for m in %w(head get post put patch delete options) %}
    macro {{m.id}}(*args)
      route({{m}}, \{{*args}})
    end
  {% end %}

end # === module DA_ROUTER

