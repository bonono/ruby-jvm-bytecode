# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jvm_bytecode/version'

Gem::Specification.new do |spec|
  spec.name          = "jvm_bytecode"
  spec.version       = JvmBytecode::VERSION
  spec.authors       = ["bonono"]
  spec.email         = ["bonono.jp@gmail.com"]

  spec.summary       = %q{Tool for generating and decoding JVM bytecode}
  spec.description   = %q{Tool for generating and decoding JVM bytecode}
  spec.homepage      = "https://github.com/bonono/ruby-jvm-bytecode"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
