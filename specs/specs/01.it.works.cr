
class IT_WORKS

  include DA_ROUTER

  getter ctx : CTX

  get "/" do
    ctx.results = "root /"
  end # === def get_root

  get "/hello/:name" do
    ctx.results = "Hello, #{name}"
  end # === def get_hello

  get "/hello/:outer/:world" do
    ctx.results = "Hello, #{outer} -> #{world}"
  end # === def get_hello_type

  def self.run(meth, path)
    ctx = CTX.new(meth, path)
    path = ctx.request.path
    case
    when path == "/"
      IT_WORKS.get("/")
    when path.split('/').size == 4
      IT_WORKS.get("/hello/:outer/:world")
    else
      IT_WORKS.get("/hello/:name")
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




