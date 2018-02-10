
# require "../src/da_router"
require "spec"

class CTX

  getter :request
  property :results

  def initialize(*args)
    @request = Request.new(*args)
    @results = ""
  end # === def initialize

  struct Request

    getter :path, :method
    def initialize(@method : String, @path : String)
      @results = ""
    end # === def initialize

  end # === struct Request
end

require "./specs/*"

