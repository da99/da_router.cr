

require "file_utils"
FILE_NAME = File.expand_path("tmp/da_routes.txt")
Dir.mkdir_p("tmp")

case ARGV.first?

when "reset"
  if File.exists?(FILE_NAME)
    FileUtils.rm FILE_NAME
  end

when "new_route"
  content = IO::Memory.new
  if File.exists?(FILE_NAME)
    content << File.read(FILE_NAME)
  end

  content << "\n"
  ARGV[1..-1].each { |x|
    content << " " << x
  }
  File.write(FILE_NAME, content.to_s)

when "get_code"
  raw = File.read(FILE_NAME).split("\n").map(&.strip).reject(&.empty?)
  content = IO::Memory.new
  raw.each { |line|
    http_method, path, klass, meth_sym = line.split
    content << "\n"
    content << "#{http_method} #{path} #{klass} #{meth_sym}"
  }
  puts content.to_s

else
  STDERR.puts "!!! Invalid option: #{ARGV.inspect}"
  Process.exit(1)
end
