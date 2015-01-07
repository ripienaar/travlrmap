module Travlrmap
  class SinatraApp < ::Sinatra::Base
    def initialize(config)
      @config = config
      @map = @config[:map]
      @types = @config[:types]

      raise "The constant APPROOT should be set in config.ru to the directory your webserver is serving from" unless defined?(APPROOT)
      raise "The directory %s set in APPROOT does not exist" % APPROOT unless File.directory?(APPROOT)

      load_map

      super()
    end

    set :static, true
    set :views, File.join(File.expand_path(File.dirname(__FILE__)), "../..", "views")
    set :public_folder, File.join(File.expand_path(File.dirname(__FILE__)), "../..", "public")

    helpers do
      include Rack::Utils

      alias_method :h, :escape_html

      def base_url
        @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
      end
    end

    def kml_style_url(type)
      "travlrmap-%s-style" % type
    end

    def load_map
      @points = []

      Array(@config[:map][:data]).each do |map|
        point_file = File.join(File.join(APPROOT, "config", map))
        data = YAML.load_file(point_file)

        @points.concat(data[:points])
      end
    end

    def set_map_vars(view)
      @map_view = @config[:views][view]
      @zoom_control = @map[:zoom_control].nil? ? true : @map[:zoom_control]
      @map_type_control = @map[:map_type_control].nil? ? true : @map[:map_type_control]
      @street_view_control = @map[:street_view_control].nil? ? false : @map[:street_view_control]
      @overview_control = @map[:overview_control].nil? ? false : @map[:overview_control]
      @pan_control = @map[:pan_control].nil? ? true : @map[:pan_control]
    end

    def to_json
      @points.sort_by{|p| p[:country]}.map do |point|
        point[:popup_html] = erb(:"_point_comment", :layout => false, :locals => {:point => point})
        point[:icon] = @types[ point[:type] ][:icon]
        point
      end.to_json
    end

    def to_kml
      require 'ruby_kml'

      kml = KMLFile.new
      document = KML::Document.new(:name => "Travlrmap Data")
      folder = KML::Folder.new(:name => "Countries")
      folders = {}

      @types.each do |k, t|
        document.styles << KML::Style.new(
          :id         => kml_style_url(k),
          :icon_style => KML::IconStyle.new(:icon => KML::Icon.new(:href => t[:icon]))
        )
      end

      @points.sort_by{|p| p[:country]}.each do |point|
        unless folders[point[:country]]
          folder.features << folders[point[:country]] = KML::Folder.new(:name => point[:country])
        end

        f = folders[point[:country]]

        f.features << KML::Placemark.new(
          :name        => point[:title],
          :description => erb(:"_point_comment", :layout => false, :locals => {:point => point}),
          :geometry    => KML::Point.new(:coordinates => {:lat => point[:lat], :lng => point[:lon]}),
          :style_url   => "#%s" % kml_style_url(point[:type])
        )
      end

      document.features << folder
      kml.objects << document

      kml.render
    end

    get '/view/:view' do
      params[:view] ? view = params[:view].intern : view = :default

      set_map_vars(view)
      erb :index
    end

    get '/' do
      set_map_vars(:default)
      erb :index
    end

    get '/geocode' do
      erb :geolocate
    end

    get '/points/kml' do
      content_type :"application/vnd.google-earth.kml+xml"
      to_kml
    end

    get '/points/json' do
      content_type :"application/json"
      to_json
    end

    post '/points/validate' do
      content_type :"application/json"

      data = JSON.parse(request.body.read)

      point = {}

      ["title", "comment", "country", "date", "href", "linktext", "linkimg", "lon", "lat"].each do |i|
        if data[i].is_a?(String)
          point[i.intern] = data[i] unless data[i].empty?
        else
          point[i.intern] = data[i]
        end
      end

      point[:type] = data["type"].intern

      result = {"yaml" => YAML.dump([point]).lines.to_a[1..-1].join,
                "html" => erb(:"_point_comment", :layout => false, :locals => {:point => point})}

      result.to_json
    end

    get '/images/*' do
      requested_file = params[:splat].first
      file = File.expand_path(File.join("images", requested_file), APPROOT)

      if File.exist?(file)
        send_file(file)
      else
        status 404
        "Not Found"
      end
    end
  end
end
