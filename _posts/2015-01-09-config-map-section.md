---
layout: page
title: "Config - Map section"
category: ref
date: 2015-01-09 18:44:07
order: 0
---

The main section of the configuration file is the ```map``` section, the supplied one will work out of the box, you'll need to tweak it if you want to change the title, icon sets, clustering options etc.

A full section with all options shown can be seen below, refernce for each can be seen below:

```YAML
:map:
  :data:
    - europe.yaml
    - america.yaml
  :width: "80%"
  :height: "90%"
  :zoom_control: true
  :map_type_control: true
  :street_view_control: true
  :overview_control: false
  :pan_control: true
  :title: My Travels
  :cluster: true
  :cluster_grid_size: 40
  :cluster_minumum_size: 2
  :cluster_zoom_on_click: true
  :cluster_image_path: /cluster/cluster-RED-
  :cluster_image_extension: png
  :cluster_image_sizes: [25, 27, 31, 37, 43]
  :show_geocode_link: true
  :authenticate: false
  :admin_user: admin
  :admin_salt: d34fda332c9a0f8997d33db8172b67b1a319fd79d108568aa4fbdb2b
  :admin_hash: 267d09bb203ec5c9a20eb7dbc1a
  :google_analytics_id: UA-99999999-9
```
