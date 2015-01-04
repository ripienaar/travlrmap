#!/usr/bin/ruby


COLORS = {
  "aqua" => "00ffff",
  "black" => "000000",
  "blue"  => "0000ff",
  "fuchsia" => "ff00ff",
  "gray" => "808080",
  "green" => "008000",
  "lime" => "00ff00",
  "maroon" => "800000",
  "navy" => "000080",
  "olive" => "808000",
  "orange" => "ffa500",
  "purple" => "800080",
  "red" => "ff0000",
  "silver" => "c0c0c0",
  "teal" => "008080",
  "white" => "ffffff",
  "yellow" => "ffff00"
}

SIZES = {
  "mini" => [16,16],
  "regular" => [32,32],
  "large" => [48,48]
}

SIZES.each do |size_name, size|
  COLORS.each do |color_name, color|
    url = "http://chart.apis.google.com/chart?cht=mm&chs=%dx%d&chco=FFFFFF,%s,000000&ext=.png" % [size[0], size[1], color]

    image_name = "marker-%s-%s.png" % [color_name.upcase, size_name.upcase]

    puts image_name
    system("curl -so %s '%s'" % [image_name, url])
    sleep 0.5
  end
end
