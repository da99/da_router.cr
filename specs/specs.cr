
require "../src/da_router"

struct MAIN

  getter :ctx
  def initialize(@ctx : CTX)
  end # === def initialize

  def get_hello(name : String)
    puts "Hello, #{name}"
  end # === def get_hello

  def get_hello_type(t : String, w : String)
    puts "Hello, #{t} -> #{w}"
  end # === def get_hello_type

end # === struct MAIN

struct CTX
  getter :path, :http_method
  def initialize(@http_method : String, @path : String)
  end # === def initialize
end

include DA_ROUTER
ctx    = CTX.new("GET", "/hello/kevin.smith")
crumbs = to_crumbs(ctx.path)
get("/hello/:world", MAIN, :hello)

ctx    = CTX.new("GET", "/hello/outer/world")
crumbs = to_crumbs(ctx.path)
get("/hello/:outer/:world", MAIN, :hello_type)



