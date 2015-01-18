module Travlrmap
  module Util
    def self.kml_style_url(key, type)
      "travlrmap-%s-%s" % [key, type]
    end

    def self.domain_from_url(url)
      host = URI.parse(url).host.downcase
      host.start_with?(/(en|www)\./) ? host[4..-1] : host
    end

    def self.point_from_json(json)
      Point.new(json, @types, :json)
    end
  end
end
