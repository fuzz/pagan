# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pagan/version"

Gem::Specification.new do |spec|
  spec.name          = "pagan"
  spec.version       = Pagan::VERSION
  spec.authors       = ["Fuzz Leonard"]
  spec.email         = ["fuzz@fuzzleonard.com"]
  spec.summary       = %q{Zapp tracker}
  spec.description   = %q{A zapp tracker.}
  spec.homepage      = "https://github.com/fuzz/pagan"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "pg"
  spec.add_dependency "sequel"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rack-test"
end
