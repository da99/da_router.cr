
require "../src/da_router"

struct CTX
  getter :path, :http_method
  def initialize(@http_method : String, @path : String)
  end # === def initialize
end

require "./specs/*"

