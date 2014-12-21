#!/usr/bin/ruby

$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'net/http'
require 'open-uri'
require 'json'
require 'gli'
require 'travlrmap'
require 'pp'
require 'yaml'

include GLI::App

def get_component_by_type(address, type)
  component = Array(address.select {|a| a["types"].include?(type)})

  raise("Could not find a component of type %s" % type) if component.empty?

  component.first["long_name"]
end

program_desc "Travlrmap geoencoder"
version Travlmap::VERSION

desc 'Search for a specific location'

command :search do |c|
  c.desc 'Comment associated with the location'
  c.flag [:comment, :c], :required => true

  c.desc 'URL to link this item to'
  c.flag [:href]

  c.desc 'Text to use for the HREF, cannot combine with --linkimg'
  c.flag [:linktext]

  c.desc 'Instead of some text show a clickable image instead'
  c.flag [:linkimg]

  c.desc 'Visit type'
  c.flag [:type, :t], :required => true

  c.action do |go, o, args|
    raise("Cannot specify both --linktext and --linkimg") if o[:linktext] && o[:linkimg]
    raise("Need --linktext or --linkimg when specifying --href") if (o[:href] && !(o[:linktext] || o[:linkimg]))

    location = args[0] || raise("Please specify a place to search for as first argument")

    url = "http://maps.googleapis.com/maps/api/geocode/json?address=%s" % URI::encode(location)

    resp = Net::HTTP.get_response(URI.parse(url))

    if resp.code == "200"
      georesult = JSON.parse(resp.body)

      if georesult["status"] == "OK"
        result = georesult["results"][0]
        record = {}

        record[:lon] = result["geometry"]["location"]["lng"]
        record[:lat] = result["geometry"]["location"]["lat"]
        record[:title] = get_component_by_type(result["address_components"], "locality")
        record[:country] = get_component_by_type(result["address_components"], "country")
        record[:comment] = o[:comment]
        record[:type] = o[:type].intern
        record[:linktext] = o[:linktext] if o[:linktext]
        record[:linkimg] = o[:linkimg] if o[:linkimg]
        record[:href] = o[:href] if o[:href]

        puts YAML.dump([record])
      else
        puts "Failed to geocode %s:" % location
        pp georesult
      end
    else
      raise("Could not retrieve location information from Google geocode service: code: %s message: %s" % [resp.code, resp.message])
    end
  end
end

exit run(ARGV)
