# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "starenv"
  spec.version       = '0.0.3'
  spec.authors       = ["Chris Keele"]
  spec.email         = ["dev@chriskeele.com"]
  spec.summary       = 'Load and manage suites of environment variables.'
  spec.description   = "Declare multiple '.env' files, set up dynamic load orders between them, and use rake tasks to keep them up to date and documented."
  spec.homepage      = "https://github.com/christhekeele/starenv"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  # spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.1'

  spec.add_runtime_dependency "rake"
  spec.add_runtime_dependency "highline"

  spec.add_development_dependency "bundler", "> 1.3"
  spec.add_development_dependency "pry"
end
