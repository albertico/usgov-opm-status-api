# frozen_string_literal: true

require_relative "lib/usgov/opm/status/api/version"

Gem::Specification.new do |spec|
  spec.name = "usgov-opm-status-api"
  spec.version = USGov::OPM::Status::API::VERSION
  spec.authors = ["Alberto Colón Viera"]
  spec.email = ["aacv@albertico.dev"]

  spec.summary = "Ruby client for the Operating Status API of the U.S. Office of Personnel Management."
  spec.description = "Ruby client for the Operating Status API of the U.S. Office of Personnel Management."
  spec.homepage = "https://github.com/albertico/usgov-opm-status-api"
  spec.required_ruby_version = ">= 3.3"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/albertico/usgov-opm-status-api"
  spec.metadata["changelog_uri"] = "https://github.com/albertico/usgov-opm-status-api"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_dependency "http", "~> 5.1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
