require 'open3'

module Grapht
  module Shell
    class Error < StandardError; end
    
    CMD = File.join(Grapht::ROOT, 'bin/grapht')

    def self.exec(type, json_data)
      out, err, status = Open3.capture3 CMD, type, stdin_data: json_data
      raise Grapht::Shell::Error, err unless status.success?
      out
    end
  end
end
