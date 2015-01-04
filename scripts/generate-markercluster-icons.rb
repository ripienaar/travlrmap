#!/usr/bin/ruby


SIZES = [24, 26, 31, 37, 43]

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

SIZES.each_with_index do |size, index|
  COLORS.each do |color_name, color|
    url = "http://chart.apis.google.com/chart?cht=it&chs=%dx%d&chco=%s,000000ff,ffffff01&chl=&chx=000000,0&chf=bg,s,00000000&ext=.png" % [size, size, color]

    image_name = "cluster-%s-%d.png" % [color_name.upcase, index + 1]

    puts image_name
    system("curl -so %s '%s'" % [image_name, url])
    sleep 0.5
  end
end
