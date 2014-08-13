require 'open3'

module Grapht
  module Shell
    class Error < StandardError; end

    CMD = File.join(Grapht::ROOT, 'bin/grapht')
    ALLOWED_OPTIONS  = %w(-f)

    def self.exec(type, json_data, options={})
      options = *options.select { |k,v| ALLOWED_OPTIONS.include? k }.flatten

      out, err, status =
        Open3.capture3 CMD, type, *options, stdin_data: json_data, binmode: true
        
      raise Grapht::Shell::Error, err unless status.success?
      out
    end
  end
end
