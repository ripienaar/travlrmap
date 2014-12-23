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

    def to_kml
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
          :description => point[:comment],
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

    get '/kml' do
      content_type :"application/vnd.google-earth.kml+xml"
      to_kml
    end
  end
end
