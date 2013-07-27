# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-ami/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-ami"
  spec.version       = Vagrant::Ami::VERSION
  spec.authors       = "Mike Ryan"
  spec.email         = "mike@epitech.nl"
  spec.description   = "Enables Vagrant to create EC2 AMIs."
  spec.summary       = "Enables Vagrant to create EC2 AMIs."
  spec.homepage      = "http://www.epitech.nl"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "vagrant-aws"
end
