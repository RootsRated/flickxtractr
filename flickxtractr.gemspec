# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flickxtractr/version'

Gem::Specification.new do |spec|
  spec.name          = "flickxtractr"
  spec.version       = Flickxtractr::VERSION
  spec.authors       = ["RootsRated"]
  spec.email         = ["developers@rootsrated.com"]
  spec.summary       = %q{An image +meta extraction tool}
  spec.description   = %q{An image +meta extraction tool}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w{app lib}

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "sinatra"
end
