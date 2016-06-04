# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vandelay/version'

Gem::Specification.new do |spec|
  spec.name          = "vandelay"
  spec.version       = Vandelay::VERSION
  spec.authors       = ["Dean Silfen"]
  spec.email         = ["dean.silfen@gmail.com"]

  spec.summary       = %q{An implmentation of the builder pattern for lightweight transport objects}
  spec.description   = %q{This is one implementation of the [Builder Pattern](https://en.wikipedia.org/wiki/Builder_pattern) in the Ruby programming language. This is primarily used for composing objects to transport a set of data to a receiver with a specific payload. The advantage of using a builder over a plain Hash is using explicit methods to set required fields, and getting a common way to present your data to the receiver. By default, `.build` will transform your data into a hash, but you can override this method to create your preferred format.}
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.required_ruby_version = '>= 2.1.0'
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1.0"
  spec.add_development_dependency "yard", "~> 0.8.7.6"
end
