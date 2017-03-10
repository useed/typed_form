# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'typed_form/version'

Gem::Specification.new do |spec|
  spec.name          = "typed_form"
  spec.version       = TypedForm::VERSION
  spec.authors       = ["Rob Cole", "Tim Walsh"]
  spec.email         = ["robcole@useed.org", "tim@useed.org"]

  spec.summary       = %q{typed_form provides an interface for retrieving
                          results from Typeform surveys and interpolating
                          them into a presentable Q&A format. }
  spec.description   = %q{Typeform exposes a robust schema for form data via
                          their data API. typed_form facilitates the ability
                          to present this data in an easily presentable format
                          by adding types, extrapolating "piped" questions into
                          their full text, and associating questions directly
                          with answers.}
  spec.homepage      = "https://github.com/useed/typed_form"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/}) || f.match(%r{\.gem})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.14"
  spec.add_dependency "arendelle", "~> 0.1"
  spec.add_development_dependency "byebug", "~> 9.0"
  spec.add_development_dependency "webmock", "~> 2.3"
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
