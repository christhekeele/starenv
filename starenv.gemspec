# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'starenv/version'

Gem::Specification.new do |spec|
  spec.name          = "starenv"
  spec.version       = Starenv::VERSION
  spec.authors       = ["Chris Keele"]
  spec.email         = ["dev@chriskeele.com"]
  spec.summary       = "Manage and permute multiple *.env files."
  spec.description   = <<-DESC
    Manage and permute multiple *.env files.
    
    Allows you to split up your .env files into more managable chunks, conditionally
    load them, see where each variable comes from, and provides a .env setup script.
  DESC
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_dependency "block_party"
  spec.add_dependency "dotenv"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
