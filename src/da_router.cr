

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

  def to_crumbs(str)
    str.split("/").reject { |s| s.empty? }
  end # === def self.split_path

  macro path_to_tuple(path)
    {% pieces = path.split("/").reject { |x| x.empty? }.map { |x| x[0..0] == ":" ? x.id : x.stringify } %}
    { {{pieces.join(", ").id}} }
  end # === macro to_tuple

  macro route(http_method, path, klass, meth)
    if DA_ROUTER.is_match?(crumbs, path_to_tuple({{path}})) && ctx.http_method == "{{http_method.upcase.id}}"
      {{klass}}.new(ctx).{{http_method.downcase.id}}_{{meth.id}}(
        {%
         positions = [] of StringLiteral
         i = -1
         path.split("/").reject { |s| s.empty? }.map { |s|
           i = i + 1
           if s[0..0] == ":"
             positions.push("crumbs[" + i.stringify + "]")
           else
             nil
           end
         }.reject { |v| !v }
         %}
        {{positions.join(", ").id}}
      )
    end
  end # === macro match

  {% for m in [:head, :get, :post, :put, :delete] %}
    macro {{m.id}}(*args)
      route({{m}}, \{{*args}})
    end
  {% end %}

end # === module DA_ROUTER

