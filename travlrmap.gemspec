$: << File.expand_path("../lib", __FILE__)

require 'travlrmap/version'

Gem::Specification::new do |spec|
  spec.name = "travlrmap"
  spec.version = Travlmap::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.summary = "travlrmap"
  spec.description = "description: Sinatra based map builder"

  spec.files = Dir["lib/**/*.rb", "views/**/*", "public/**/*", "config/travlrmap.yaml.dist", "config.ru", "Gemfile", "Gemfile.lock"]
  spec.executables = []

  spec.require_path = "lib"

  spec.has_rdoc = false
  spec.test_files = nil

  spec.add_dependency 'sinatra'
  spec.add_dependency 'bundler'
  spec.add_dependency 'httparty'
  spec.add_dependency 'ruby_kml'
  spec.add_dependency 'gli'
  spec.add_dependency 'httparty', '0.11.0'
  spec.add_dependency 'nokogiri', '1.5.2'

  spec.extensions.push(*[])

  spec.author = "R.I.Pienaar"
  spec.email = "rip@devco.net"
  spec.homepage = "http://devco.net/"
end
