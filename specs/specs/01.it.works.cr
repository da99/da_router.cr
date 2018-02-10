
class IT_WORKS

  getter ctx : CTX
  def initialize(@ctx)
  end # === def initialize

  def root
    ctx.results = "root /"
  end

  def hello(name)
    ctx.results = "Hello, #{name}"
  end

  # /hello/:outer/:world
  def hello(outer, world)
    ctx.results = "Hello, #{outer} -> #{world}"
  end

  def self.run(meth, path)
    ctx = CTX.new(meth, path)
    path = ctx.request.path
    case
    when path == "/"
      IT_WORKS.new(ctx).root

    when path.split('/').size == 4
      pieces = path.split('/')
      IT_WORKS.new(ctx).hello( pieces[-2], pieces[-1] )

    else
      pieces = path.split('/')
      IT_WORKS.new(ctx).hello(pieces.last)

    end
    ctx.results
  end # === def routes

end # === struct IT_WORKS

describe "DA_ROUTER" do

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




