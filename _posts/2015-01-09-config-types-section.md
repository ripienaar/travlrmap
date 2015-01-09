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

You can provide your own by placing them in ```images``` in your repo and linking to them here.
