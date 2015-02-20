# encoding: utf-8
module Travlrmap
  module Gallery
    def self.gallery_type(type)
      require 'travlrmap/gallery/%s' % type.downcase
      self.const_get(type.capitalize)
    rescue LoadError
      raise "Unknown gallery type %s" % type
    end

    def self.url_from_spec(spec)
      if spec =~ /^(.+?),(.+)$/
        type = $1.capitalize
        options = $2

        options = Hash[options.split(",").map{|i| i.split("=")}]

        gallery_type(type).url_from_spec(options)
      end
    end
  end
end

