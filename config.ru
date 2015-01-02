$: << File.join(File.dirname(__FILE__), "lib")

Bundler.require(:default)

require 'travlrmap'

set :run, false

APPROOT = File.dirname(__FILE__)
config = YAML.load_file(File.join(APPROOT, "config", "travlrmap.yaml"))

run Travlrmap::SinatraApp.new(config)
