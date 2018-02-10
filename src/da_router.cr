
require "http"

module DA_ROUTER

  MACRO_ASCII_CODES = {} of _ => _

  {% for x in system(%[ruby #{__DIR__}/../scripts/ascii_codes.rb]).strip.split("\n") %}
    {% key = x.split.first %}
    {% code = x.split.last %}
    {% MACRO_ASCII_CODES[key.id] = code.id %}
  {% end %}

  macro get(*args, &blok)
    {% name = "get_#{args.last.id.chars.map { |x| MACRO_ASCII_CODES[x.id] }.join("_").id}".id %}
    {% if blok %}
      def {{name}}
        {% count = 0 %}
        {% for x in args.last.split("/") %}
          {% if !x.empty? %}
            {% count = count + 1 %}
            {% if x.includes?(":") %}
              {{x.gsub(/^:/, "").id}} = ctx.request.path.split('/')[{{count}}]
            {% end %}
          {% end %}
        {% end %}
        {{blok.body}}
      end
    {% else %}
      {{@type}}.new(ctx).{{name}}
    {% end %}
  end

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

  {% for m in %w(head get post put patch delete options) %}
    # macro {{m.id}}(path, &blok)
    # end
  {% end %}


end # === module DA_ROUTER

