# encoding: utf-8
module Travlrmap
  class Point
    def initialize(from, types, type=:json)
      @point = {}
      @types = types

      if from.is_a?(Hash)
        from_hash(from)
      elsif from.is_a?(String)
        if type == :json
          from_json(from)
        else
          from_yaml(from)
        end
      end
    end

    def preview
      {"yaml" => YAML.dump([self.to_hash]).lines.to_a[1..-1].join,
       "html" => self.to_html}
    end

    def type
      @types[ self[:type] ]
    end

    def h(string)
      Rack::Utils.escape_html(string)
    end

    def [](key)
      @point.fetch(key, nil)
    end

    def []=(key, val)
      @point[key] = val
    end

    def fetch(key, default)
      @point.fetch(key, default)
    end

    def to_html(title=true)
      ERB.new(point_html_template, nil, "<>").result(binding)
    end

    def to_json
      @point.to_json
    end

    def to_hash
      @point.clone
    end

    def to_placemark
      KML::Placemark.new(
        :name        => self[:title],
        :description => to_html(false),
        :geometry    => KML::Point.new(:coordinates => {:lat => self[:lat], :lng => self[:lon]}),
        :style_url   => "#%s" % Util.kml_style_url(self[:type], :type)
      )
    end

    private
    def from_json(from)
      p = JSON.parse(from)
      data = {}

      p.each_pair{|k, v| data[k.intern] = v}

      from_hash(data)
    end

    def from_yaml(from)
      from_hash(YAML.load(from))
    end

    def from_hash(data)
      [:title, :comment, :country, :date, :href, :linktext, :linkimg, :lon, :lat, :type, :gallery].each do |i|
        next if data[i].to_s.empty?

        if data[i].is_a?(String)
          @point[i] = data[i]
        else
          @point[i] = data[i]
        end
      end

      @point[:type] = data[:type].intern unless data[:type].is_a?(Symbol)
    end

    def point_html_template
      if [:gallery, :track].include?(@point[:type])
        file = "%s.erb" % @point[:type]
      else
        file = "generic.erb"
      end

      File.read(File.join(Util.template_dir, "point_types", file))
    end
  end
end
