
require "http"

class Scratch

  include DA_ROUTER

  def write(s)
    ctx.response << s
  end

  get "/" do
    ctx.response.content_type = "text/html; charset=utf-8"
    ctx.response << "hello #{ ctx.request.method }"
  end # === def get_root

  get "/hello/world" do
    write "Hello, World: #{ ctx.request.method }"
  end # === def get_hello

  get "/hello/the/entire/world" do
    write "Hello, The Entire World: #{ ctx.request.method }"
  end # === def get_hello_more

  def self.fulfill(ctx)
    DA_ROUTER.route!(ctx)
    ctx.response.status_code = 404
    ctx.response << "missing: #{ ctx.request.method } #{ctx.request.path}"
  end

end # === class Scratch

server = HTTP::Server.new(3000) do |ctx|
  Scratch.fulfill(ctx)
end

server.listen






