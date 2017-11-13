
describe "Compiling" do
  it "removes tmp files" do
    Dir.glob("/tmp/da_router.*").empty?.should eq(true)
  end # === it "removes tmp files"
end # === desc "Compiling"
