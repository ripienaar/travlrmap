---
layout: page
title: "Config - Views section"
category: ref
date: 2015-01-09 19:22:50
order: 1
---

Views appear at the top of the site in a menu and allow you to define view ports to help users of the site zoom in to predefined locations you choose.

```YAML
:views:
  :default:
    :lat: 20
    :lon: 0
    :zoom: 2
    :description: World
  :europe:
    :lat: 48.195387
    :lon: 10.634766
    :zoom: 6
    :description: Europe
```

The easiest way to get the coordinates and zoom value is to browse to [Google Maps](https://maps.google.com/) to the location and view you like and just grab these values from the URL bar.

The ```:default:``` view is what will be shown if someone browse to your main landing url.
