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
      {"yaml" => YAML.dump([self]).lines.to_a[1..-1].join,
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

    def to_yaml(opts)
      @point.to_yaml(opts)
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
      [:title, :comment, :country, :date, :href, :linktext, :linkimg, :lon, :lat, :type].each do |i|
        if data[i].is_a?(String)
          @point[i] = data[i] unless data[i].empty?
        else
          @point[i] = data[i]
        end
      end

      @point[:type] = data[:type].intern unless data[:type].is_a?(Symbol)
    end

    def point_html_template
      <<-EOS
<p>
<% if title %><font size="+2"><%= @point[:title] %></font><% end %>
<hr>
<% if @point[:comment] %>
<%=  h @point[:comment] %><br /><br />
<% end %>
<% if @point[:href]  %>
     <a href='<%= @point[:href] %>' target='_blank'>
<% end %>
<% if @point[:linkimg] || @point[:linktext] %>
<%   if @point[:linkimg] %>
       <img src='<%= @point[:linkimg] %>'><br />
<%   end %>
<%   if @point[:linktext] %>
       <%= h @point[:linktext] %>
<%   end %>
<% elsif @point[:href] %>
     <%= Util.domain_from_url(@point[:href]) %>
<% end %>
<% if @point[:href]  %>
     </a>
<% end %>
</p>
<p>
<font weight"-2"><%= h @types[ @point[:type] ][:description] %><% if @point[:date] %> on <%= h @point[:date] %><% end %>
      EOS
    end
  end
end
