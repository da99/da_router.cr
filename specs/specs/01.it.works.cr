
struct MAIN

  getter :ctx
  def initialize(@ctx : CTX)
  end # === def initialize

  def get_hello(name : String)
    ctx.results = "Hello, #{name}"
  end # === def get_hello

  def get_hello_type(t : String, w : String)
    ctx.results = "Hello, #{t} -> #{w}"
  end # === def get_hello_type

end # === struct MAIN

describe "it works" do
  it "routes to a get method" do
    ctx = CTX.new("GET", "/hello/kevin.smith")
    route(ctx) do
      get("/hello/:world", MAIN, :hello)
    end
    ctx.results.should eq("Hello, kevin.smith")
  end # === it "routes to a get method"

  it "passes multiple params to method" do
    ctx = CTX.new("GET", "/hello/my/world")
    route(ctx) do
      get("/hello/:outer/:world", MAIN, :hello_type)
    end
    ctx.results.should eq("Hello, my -> world")
  end # === it "passes multiple params to method"
end # === desc "it works"




