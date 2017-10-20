
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

include DA_ROUTER

route(CTX.new("GET", "/hello/kevin.smith")) do
  get("/hello/:world", MAIN, :hello)
end

route(CTX.new("GET", "/hello/outer/world")) do
  get("/hello/:outer/:world", MAIN, :hello_type)
end
