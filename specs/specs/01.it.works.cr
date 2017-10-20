
struct IT_WORKS

  getter :ctx
  def initialize(@ctx : CTX)
  end # === def initialize

  def get_root
    ctx.results = "root /"
  end # === def get_root

  def get_hello(name : String)
    ctx.results = "Hello, #{name}"
  end # === def get_hello

  def get_hello_type(t : String, w : String)
    ctx.results = "Hello, #{t} -> #{w}"
  end # === def get_hello_type

  def self.run(meth, path)
    ctx = CTX.new(meth, path)
    route(ctx) do
      get("/", IT_WORKS, :root)
      get("/hello/:world", IT_WORKS, :hello)
      get("/hello/:outer/:world", IT_WORKS, :hello_type)
    end
    ctx.results
  end # === def routes

end # === struct IT_WORKS

describe DA_ROUTER do

  it "routes root path" do
    IT_WORKS.run("GET", "/")
      .should eq( "root /" )
  end # === it "routes root path"

  it "routes to a get method" do
    IT_WORKS.run("GET", "/hello/kevin.smith")
      .should eq("Hello, kevin.smith")
  end # === it "routes to a get method"

  it "passes multiple params to method" do
    IT_WORKS.run("GET", "/hello/my/world")
      .should eq("Hello, my -> world")
  end # === it "passes multiple params to method"

end # === desc "it works"




