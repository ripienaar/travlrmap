#!/usr/bin/ruby

# grab the zip files from http://mapicons.nicolasmollet.com/ and place them
# here without any renames etc, run this and get directories full of markers
# in the same directory as the zips

require 'fileutils'

Dir.entries(".").grep(/^mapiconscollection.+zip$/).each do |collection_file|
  if collection_file =~ /^mapiconscollection-(.+)-.{6}-default.zip/
    collection = $1

    FileUtils.mkdir_p(collection)
    Dir.chdir(collection) do
      system("unzip ../%s" % collection_file)
    end
  end
end
