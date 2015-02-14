# encoding: utf-8
module Travlrmap
  module Util
    def self.kml_style_url(key, type)
      "travlrmap-%s-%s" % [key, type]
    end

    def self.domain_from_url(url)
      host = URI.parse(url).host.downcase
      host.match(/^(en|www)\./) ? host.split(".")[1..-1].join(".") : host
    end

    def self.point_from_json(json, types)
      Point.new(json, types, :json)
    end
  end
end
