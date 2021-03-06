# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "guard/espect/version"

Gem::Specification.new do |s|
  s.name        = "guard-espect"
  s.version     = Guard::EspectVersion::VERSION
  s.author      = "David Runger"
  s.email       = "daverunger@gmail.com"
  s.summary     = "Guard gem for RSpec"
  s.description = "Guard::Espect automatically run your specs."

  s.homepage    = "https://github.com/davidrunger/guard-espect"
  s.license     = "MIT"

  s.files        = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.test_files   = s.files.grep(%r{^spec/})
  s.require_path = "lib"

  s.add_dependency "guard", "~> 2.1"
  s.add_dependency "guard-compat", "~> 1.1"
  s.add_dependency "rspec", ">= 2.99.0", "< 4.0"
end
