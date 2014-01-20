# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bucket/version'

Gem::Specification.new do |spec|
  spec.name          = "bucket-cli"
  spec.version       = Bucket::VERSION
  spec.authors       = ["Roberto Poo"]
  spec.email         = ["xaro@poo.cl"]
  spec.description   = %q{CLI for BitBucket}
  spec.summary       = %q{Easily clone and create repositories in BitBucket from the command line.
                          Init and link the local repository with a new BitBucket one in one command.}
  spec.homepage      = "https://github.com/xaro/bucket"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "omniauth"
  spec.add_dependency "thor"
  spec.add_dependency "bitbucket_rest_api"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"

  # Fake the filesystem
  spec.add_development_dependency "fakefs"

  # Mocks
  spec.add_development_dependency "rr"
end
