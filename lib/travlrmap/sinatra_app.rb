module Travlrmap
  class SinatraApp < ::Sinatra::Base
    def initialize(config)
      @config = config
      @config[:sets] ||= {}
      @map = @config[:map]
      @types = @config[:types]
      @sets = @config[:sets] || {}
      @js_map_update = false

      raise "The constant APPROOT should be set in config.ru to the directory your webserver is serving from" unless defined?(APPROOT)
      raise "The directory %s set in APPROOT does not exist" % APPROOT unless File.directory?(APPROOT)

      @map[:map_types] = ["hybrid", "roadmap", "satellite", "terrain", "osm"] unless @map[:map_types]
      @map[:default_map_type] = "roadmap" unless @map[:default_map_type]

      super()
    end

    set :static, true
    set :views, File.join(File.expand_path(File.dirname(__FILE__)), "../..", "views")
    set :public_folder, File.join(File.expand_path(File.dirname(__FILE__)), "../..", "public")

    helpers do
      include Rack::Utils

      alias_method :h, :escape_html

      def protected!
        return if authorized?
        headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
        halt(401, "Not authorized\n")
      end

      def authorized?
        return true if !@map[:authenticate]

        halt(500, ":admin_salt: is not set in the config") unless @map[:admin_salt]
        halt(500, ":admin_salt: should be at least 16 characters") unless @map[:admin_salt].length >= 16
        halt(500, ":admin_user: is not set in the config") unless @map[:admin_user]
        halt(500, ":admin_hash: is not set in the config") unless @map[:admin_hash]

        @auth ||=  Rack::Auth::Basic::Request.new(request.env)

        if @auth.provided? && @auth.basic? && @auth.credentials
          provided_hash = Digest::MD5.hexdigest("%s%s" % [@map[:admin_salt], @auth.credentials[1]])

          return (@auth.credentials[0] == @map[:admin_user] && provided_hash == @map[:admin_hash])
        end

        false
      end

      def base_url
        @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
      end
    end

    def kml_style_url(type)
      "travlrmap-%s-style" % type
    end

    def load_map(set=nil)
      @points = []

      if set
        files = Array(@config[:sets][set][:data])
      else
        files = Array(@config[:map][:data])
      end

      files.each do |map|
        if map.is_a?(Symbol)
          @points.concat(load_map(map))
        else
          point_file = File.join(File.join(APPROOT, "config", map))

          if File.directory?(point_file)
            Dir.entries(point_file).grep(/\.yaml$/).each do |points|
              file = File.join(point_file, points)
              data = YAML.load_file(file)
              @points.concat(data[:points])
            end
          else
            data = YAML.load_file(point_file)
            @points.concat(data[:points])
          end
        end
      end
    end

    def set_map_vars(view, set=nil)
      @map_view = @config[:views][view]
      @zoom_control = @map[:zoom_control].nil? ? true : @map[:zoom_control]
      @map_type_control = @map[:map_type_control].nil? ? true : @map[:map_type_control]
      @street_view_control = @map[:street_view_control].nil? ? false : @map[:street_view_control]
      @overview_control = @map[:overview_control].nil? ? false : @map[:overview_control]
      @pan_control = @map[:pan_control].nil? ? true : @map[:pan_control]
      @js_map_update = true
      @active_set = set
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

    get '/view/:view/?:set?' do
      params[:view] ? view = params[:view].intern : view = :default
      params[:set] ? set = params[:set].intern : set = nil

      load_map(set)
      set_map_vars(view, set)

      erb :index
    end

    get '/set/:set' do
      params[:set] ? set = params[:set].intern : set = nil

      load_map(set)
      set_map_vars(:default, set)

      erb :index
    end

    get '/' do
      load_map
      set_map_vars(:default)

      erb :index
    end

    get '/about' do
      erb :about
    end

    get '/geocode' do
      protected!

      erb :geolocate
    end

    get '/points/kml/?:set?' do
      params[:set] ? set = params[:set].intern : set = nil

      content_type :"application/vnd.google-earth.kml+xml"
      load_map(set)
      to_kml
    end

    get '/points/json/?:set?' do
      params[:set] ? set = params[:set].intern : set = nil

      content_type :"application/json"
      load_map(set)
      to_json
    end

    post '/points/validate' do
      protected!

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
