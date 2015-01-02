require 'rubygems'
require 'bundler/setup'
require 'yaml'

Bundler.require(:default)

module Travlrmap
  require 'travlrmap/version'
  require 'travlrmap/sinatra_app'
end
