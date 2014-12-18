$: << File.join(File.dirname(__FILE__), "lib")

require 'bundler/setup'

require 'travlrmap'
require 'yaml'

set :run, false

APPROOT = File.dirname(__FILE__)

config = YAML.load_file(File.join(APPROOT, "config", "travlrmap.yaml"))

run Travlrmap::SinatraApp.new(config)
