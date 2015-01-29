# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minime/version'

Gem::Specification.new do |spec|
  spec.name          = "minime"
  spec.version       = Minime::VERSION
  spec.authors       = ["Fábio Luiz Nery de Miranda"]
  spec.email         = ["fabio@miranti.net.br"]
  spec.summary       = "A collection of Rails assertions and expectations"
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # assert_select / assert_select_email will be moved from Rails 4.2 to separate gem
  spec.add_dependency 'rails-dom-testing'

  spec.add_development_dependency "minitest-rails"
  spec.add_development_dependency "byebug"
end
