# frozen_string_literal: true

require_relative "lib/key_vortex/version"

Gem::Specification.new do |spec|
  spec.name = "key-vortex"
  spec.version = KeyVortex::VERSION
  spec.authors = ["Lambda Null"]
  spec.email = ["lambda.null.42@gmail.com"]

  spec.summary = "Abstraction for interacting with various record stores"
  spec.description = "Defines abstractions that can be built on top of for key/value " \
                     "storage on different technologies (file, s3, sql, redis, etc.)"
  spec.homepage = "https://github.com/Lambda-Null/key-vortex"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
