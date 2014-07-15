require 'open3'

module Grapht
  module Shell
    CMD = File.join(Grapht::ROOT, 'bin/grapht')

    def self.exec(type, json_data)
      "".tap do |result|
        Open3.popen2(CMD, type) do |stdin, stdout|
          stdin << json_data
          stdin.close

          result << stdout.read
        end
      end
    end
  end
end
