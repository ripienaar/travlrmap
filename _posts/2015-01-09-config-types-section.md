---
layout: page
title: "Config - Types section"
category: ref
date: 2015-01-09 19:27:16
order: 2
---

Points have a ```:type:``` property, you can define your own types and icons to use.

```YAML
:types:
  :visit:
    :icon: /markers/marker-RED-REGULAR.png
    :description: Visit
  :transit:
    :icon: /markers/marker-BLUE-REGULAR.png
    :description: Transit
  :lived:
    :icon: /markers/marker-GREEN-REGULAR.png
    :description: Lived
```

A number of markers in many colors and 3 sizes are [included in the Gem](https://github.com/ripienaar/travlrmap/tree/master/public/markers).

You can provide your own by placing them in ```images``` in your repo and linking to them here. You can use online services like [Google maps markers](http://www.googlemapsmarkers.com/) and link directly to them. The ones provided were made using Googles chart API using [this script](https://github.com/ripienaar/travlrmap/blob/d9cba39011256437715d64fc4d1fa3c76c09cfdf/scripts/generate-markers.rb).
