# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ajey/version'

Gem::Specification.new do |spec|
  spec.name          = "ajey"
  spec.version       = Jekyll::Ajey::VERSION
  spec.authors       = ["Frank Cieslik"]
  spec.email         = ["frank.cieslik@gmail.com"]
  spec.summary       = %q{A multi purpose pagination Jekyll.}
  spec.homepage      = "https://github.com/sss-io/ajey"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/).grep(%r{(lib/)})
  spec.require_paths = ["lib"]

  spec.add_dependency "jekyll", ENV['JEKYLL_VERSION'] ? "~> #{ENV['JEKYLL_VERSION']}" : ">= 3.0"
  spec.add_dependency "bundler", "~> 1.5"
  spec.add_dependency "vacuum", "~> 1.4.0"

  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "rspec", "~> 3.5.0"
end