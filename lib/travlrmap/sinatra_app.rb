module Travlrmap
  class SinatraApp < ::Sinatra::Base
    def initialize(config)
      @config = config
      @map = @config[:map]
      @types = @config[:types]

      load_map

      super()
    end

    set :static, true
    set :views, File.join(File.expand_path(File.dirname(__FILE__)), "../..", "views")
    set :public_folder, File.join(File.expand_path(File.dirname(__FILE__)), "../..", "public")

    helpers do
      include Rack::Utils

      alias_method :h, :escape_html
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

    get '/view/:view' do
      params[:view] ? view = params[:view].intern : view = :default

      set_map_vars(view)
      erb :index
    end

    get '/' do
      set_map_vars(:default)
      erb :index
    end
  end
end
