$: << File.expand_path("../lib", __FILE__)

require 'travlrmap/version'

Gem::Specification::new do |spec|
  spec.name = "travlrmap"
  spec.version = Travlrmap::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.summary = "travlrmap"
  spec.description = "description: Sinatra based map builder"
  spec.licenses = ["Apache-2"]

  spec.files = Dir["lib/**/*.rb", "views/**/*", "public/**/*", "config/travlrmap.yaml.dist", "config.ru", "Gemfile", "Gemfile.lock"]
  spec.executables = []

  spec.require_path = "lib"

  spec.has_rdoc = false
  spec.test_files = nil

  spec.bindir = 'bin'

  spec.add_dependency 'sinatra', '~> 1.4'
  spec.add_dependency 'httparty', '~> 0.13'
  spec.add_dependency 'json', '~> 1.8'
  spec.add_dependency 'ruby_kml', '~> 0.1'
  spec.add_dependency 'nokogiri', '~> 1.6'
  spec.add_dependency 'rack', '1.5.2'

  spec.extensions.push(*[])

  spec.author = "R.I.Pienaar"
  spec.email = "rip@devco.net"
  spec.homepage = "http://devco.net/"
end
