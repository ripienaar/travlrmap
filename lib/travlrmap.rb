require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'sinatra'
require 'json'

Bundler.require(:default)

module Travlrmap
  require 'travlrmap/version'
  require 'travlrmap/sinatra_app'
end
