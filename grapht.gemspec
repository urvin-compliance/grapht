# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grapht/version'

Gem::Specification.new do |spec|
  spec.name          = "grapht"
  spec.version       = Grapht::VERSION
  spec.authors       = ["Tim Lowrimore"]
  spec.email         = ["tim@plia.com"]
  spec.description   = %q{Grapht is a server-side graphing library built on PhantomJS and utilizing D3.js. Grapht provides a CLI for simple Bash scripting. It also profides a light-weight Ruby API to make service-level integration simple.}
  spec.summary       = %q{Grapht is a server-side graphing library built on PhantomJS and utilizing D3.js.}
  spec.homepage      = "https://github.com/ibpinc/grapht"
  spec.license       = "Proprietary"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
