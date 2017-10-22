
require "http"
require "../../../da_router.cr/src/da_router"

class Scratch

  include DA_ROUTER

  def write(s)
    ctx.response << s
  end

  def get_root
    ctx.response.content_type = "text/html; charset=utf-8"
    ctx.response << "hello #{ ctx.request.method }"
  end # === def get_root

  def get_hello
    write "Hello, World: #{ ctx.request.method }"
  end # === def get_hello

  def get_hello_more
    write "Hello, The Entire World: #{ ctx.request.method }"
  end # === def get_hello_more

  def self.fulfill(ctx)
    route(ctx) do
      get("/", Scratch, :root)
      get("/hello/world", Scratch, :hello)
      get("/hello/the/entire/world", Scratch, :hello_more)

      ctx.response.status_code = 404
      ctx.response << "missing: #{ ctx.request.method } #{ctx.request.path}"
    end
  end

end # === class Scratch

server = HTTP::Server.new(3000) do |ctx|
  Scratch.fulfill(ctx)
end

server.listen






