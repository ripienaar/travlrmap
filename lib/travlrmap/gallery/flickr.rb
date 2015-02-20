# encoding: utf-8
module Travlrmap
  module Gallery
    class Flickr
      def self.url_from_spec(options)
        "https://www.flickr.com/photos/%s/sets/%s/show/" % [options["user"], options["set"]]
      end
    end
  end
end
