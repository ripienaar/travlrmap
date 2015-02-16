# encoding: utf-8
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
      @map[:theme] = "css" unless @map[:theme]

      raise "Unknown theme %s" % @map[:theme] unless valid_themes.include?(@map[:theme])

      super()
    end

    set :static, true
    set :views, File.join(File.expand_path(File.dirname(__FILE__)), "../..", "views")
    set :public_folder, File.join(File.expand_path(File.dirname(__FILE__)), "../..", "public")

    def valid_themes
      ["cerulean", "cosmo", "cyborg", "darkly", "flatly", "journal",
       "lumen", "paper", "readable", "sandstone", "simplex", "slate",
       "spacelab", "superhero", "united", "yeti", "css"]
    end

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

        halt(500, ":admin_user: is not set in the config") unless @map[:admin_user]

        # if the webserver sets a user and its admin let her into the protected
        # areas else fail the auth
        if request.env.include?("REMOTE_USER")
          if request.env["REMOTE_USER"] == @map[:admin_user]
            return true
          else
            return false
          end
        end

        halt(500, ":admin_salt: is not set in the config") unless @map[:admin_salt]
        halt(500, ":admin_salt: should be at least 16 characters") unless @map[:admin_salt].length >= 16
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

    def load_map(set=nil)
      @points = Points.new(@types, @sets, @map)
      @points.load_points(set)
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
      @points.to_kml
    end

    get '/points/json/?:set?' do
      params[:set] ? set = params[:set].intern : set = nil

      content_type :"application/json"
      load_map(set)
      @points.to_json
    end

    post '/points/save' do
      content_type :"application/json"

      protected!

      begin
        raise("Can only save data if authentication is enabled") unless @map[:authenticate]

        raise("No :save_to location configured") unless @map[:save_to]

        save_file = File.join(APPROOT, "config", "%s.yaml" % @map[:save_to])

        raise(":save_to location is not writable") unless File.writable?(save_file)

        points = Points.new(@types, @sets, @map)
        points.load_points_from_file(save_file)

        raise("Failed to load :save_to location as valid YAML") unless points

        new_point = Util.point_from_json(request.body.read, @types)
        title = new_point[:title]

        if points.has_title?(title)
          points.replace!(title, new_point)
          result = '{"status":"success","message":"%s has been updated"}' % h(title)
        else
          points << new_point
          result = '{"status":"success","message":"%s has been saved"}' % h(title)
        end

        points.save_to_file(save_file)
      rescue Exception
        result = '{"status":"message","message":"Failed to save point: %s"}' % h($!.to_s)
      end

      result
    end

    post '/points/validate' do
      protected!

      content_type :"application/json"

      point = Util.point_from_json(request.body.read, @types)
      point.preview.to_json
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
