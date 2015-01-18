module Travlrmap
  class Points
    def initialize(types, sets, map)
      @types = types
      @sets = sets
      @map = map

      reset
    end

    def find_title(title)
      @points.find_index do |point|
        point[:title] == title
      end
    end

    def replace!(title, point)
      raise("Can only store instances of Point") unless point.is_a?(Point)

      if idx = find_title(title)
        @points[idx] = point
      else
        raise("No point with title %s to replace" % title)
      end
    end

    def save_to_file(file)
      File.open(file, "w") do |f|
        f.puts YAML.dump(:points => @points)
      end
    end

    def <<(point)
      raise("Can only store instances of Point") unless point.is_a?(Point)

      @points << point
    end

    def reset
      @points = []
    end

    def by_country
      @points.sort_by do |point|
        point[:country]
      end
    end

    def map
      by_country.map do |point|
        yield(point)
      end
    end

    def each
      by_country.each do |point|
        yield(point)
      end
    end

    def countries
      @points.map do |point|
        point[:country]
      end.sort.uniq
    end

    def size
      @points.size
    end
    alias :count :size


    def to_kml
      require 'ruby_kml'

      kml = KMLFile.new
      document = KML::Document.new(:name => "Travlrmap Data")
      folder = KML::Folder.new(:name => "Countries")
      folders = {}

      @types.each do |k, t|
        document.styles << KML::Style.new(
          :id         => Util.kml_style_url(k, :type),
          :icon_style => KML::IconStyle.new(:icon => KML::Icon.new(:href => t[:icon]))
        )
      end

      self.each do |point|
        unless folders[point[:country]]
          folder.features << folders[point[:country]] = KML::Folder.new(:name => point[:country])
        end

        f = folders[point[:country]]

        f.features << point.to_placemark
      end

      document.features << folder
      kml.objects << document

      kml.render
    end

    def to_json
      @points.map do |point|
        temp = point.to_hash
        temp[:popup_html] = point.to_html
        temp[:icon] = point.type[:icon]
        temp
      end.to_json
    end

    def load_points_from_file(file)
      points_from_data(load_file(file))
    end

    def load_points(set=nil)
      reset

      files_for_set(set).each do |file|
        if file.is_a?(Symbol)
          self.load_points(file)
        else
          file = point_file(file)

          if File.directory?(file)
            load_directory(file)
          else
            load_points_from_file(file)
          end
        end
      end
    end

    def files_for_set(set)
      return Array(@sets[set][:data]) if set
      return Array(@map[:data])
    end

    def point_file(file)
      File.join(File.join(APPROOT, "config", file))
    end

    def points_from_data(data)
      data[:points].each do |point|
        @points << Point.new(point, @types)
      end
    end

    def load_directory(directory)
      Dir.entries(directory).grep(/\.yaml$/).each do |points|
        points_from_data(load_file(File.join(directory, points)))
      end
    end

    def load_file(file)
      YAML.load_file(file)
    end
  end
end
