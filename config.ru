$: << File.join(File.dirname(__FILE__), "lib")

require 'bundler/setup'

require 'travlrmap'
require 'yaml'

set :run, false

config = YAML.load_file(File.expand_path("../config/travlrmap.yaml", __FILE__))

run Travlrmap::SinatraApp.new(config)
