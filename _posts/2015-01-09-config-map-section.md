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
  :title: My Travels
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
  :admin_salt: d34fda332a0f8997d33db8172b67b1a319fd79d108568aa4fbdb2b
  :admin_hash: 156166b575d6074b82f7f6c8453b81b8
  :google_analytics_id: UA-99999999-9
```

### Title

You can change the title shown at the top left of the page using ```:title:```

### Google Analytics

You can use [Google Analytics](http://www.google.com/analytics/) to track visitors, just put your ID into the ```::google_analytics_id:``` option.

### Points

You can store your points in many different YAML files, I store mine by country.  You can list them here, order does not matter:

```YAML
  :data:
    - europe.yaml
    - america.yaml
```

The files all have to be in the ```config``` directory for them to be found.

If you have just one file full of points you can use a shorthand:

```YAML
  :data: points.yaml
```

As of version ```1.1.0``` you can also load all YAML files in a directory as if they are points:

```YAML
  :data: travels
```

This will load ```config/travels/*.yaml``` which should all be point files.

Additionally as of version ```1.1.0``` if you have data sets defined you can designate a certain data set as default:

```YAML
  :data: :travels
```

Which requires you to have a data set called ```:travels``` defined.

### Map size and controls

On the front page you can control how much of the space the map will take, the ```width``` and ```height``` options just controls the size of the div.  You'll probably never need to change this.

```YAML
  :width: "80%"
  :height: "90%"
  :zoom_control: true
  :map_type_control: true
  :street_view_control: true
  :overview_control: false
  :pan_control: true
```

The remaining sections turns parts of the Google map UI on and off.  Adjust to taste though the defaults are probably suitable for most cases.


### Map point clustering

When there are many points close to each other the points can completely obscure the map.  We added map point clustering to address this.

```YAML
  :cluster: true
  :cluster_grid_size: 40
  :cluster_minumum_size: 2
  :cluster_zoom_on_click: true
  :cluster_image_path: /cluster/cluster-RED-
  :cluster_image_extension: png
  :cluster_image_sizes: [25, 27, 31, 37, 43]
```

The ```:cluster_grid_size:``` defines a square grid on the map, any points within the grid gets clustered into one.  As long as there are more than ```:cluster_minumum_size:``` points in the grid.  If you find too many of your points get clustered adjust these 2 settings till it works for you.

The cluster icons can be clicked and the map gets zoomed to expand to the grid covered by the cluster icon.  This can be annoying so you can disable it with ```:cluster_zoom_on_click:```.

A number of themes of clustering icons is included, see [GitHub](https://github.com/ripienaar/travlrmap/tree/master/public/cluster) for the list. If you want to use one of the ```cluster-COLOR-n.png``` ones you can just replace ```RED``` above.

But if you wanted to use the ```m1.png``` ones change ```:cluster_image_path:``` to ```/cluster/m``` and comment out ```:cluster_image_sizes:```.

You can create your own icons to match your look and feel without having to edit the gem supplied files. I create the ones included [with this script](https://github.com/ripienaar/travlrmap/blob/d9cba39011256437715d64fc4d1fa3c76c09cfdf/scripts/generate-markercluster-icons.rb).  If you tweak the sizes of the icons you should update ```:cluster_image_sizes:``` accordingly, use odd numbers for the icon sizes to ensure the text is centered.  Place yours in the ```images``` directory of your git repo and adjust ```:cluster_image_path:``` to point there.

### Map Types

As of version ```1.1.0``` a number of 3rd party Open Streetmap based map tile sets are supported.  The demo has them all enabled, the configuration to get that behavior is:

```YAML
  :map_types: [hybrid, roadmap, satellite, terrain, osm, watercolor, toner, darkmatter, positron, mapquest]
  :default_map_type: roadmap
```

For your own just list the ones you like and set the default.


### Geocode helper page

You can access the geocode helper page on ```/geocode```, by default a link to this is shown on your page.  You can hide this link using ```:show_geocode_link:```.

You can add authentication to this page - which will also be used later when we enable saving of data points. To do this you need to do a few things on a unix shell:

```YAML
  :authenticate: true
  :admin_user: admin
  :admin_salt: d34fda332a0f8997d33db8172b67b1a319fd79d108568aa4fbdb2b
  :admin_hash: 267d09bb203ec5c9a20eb7dbc1a
```

This defines the username and password.  The password is salted so it's safe to commit publically - though as always do not reuse passwords.

*NOTE:* The text below has incorrect output from the commands to avoid people having default passwords, so you need to actually run the commands.

Compute the salt:

```bash
$ openssl rand 32 -hex
d34fda332a0f8997d33db8172b67b1a319fd79d108568aa4fbdb2b
```

Compute your password by getting the md5 of the salt plus your password:

```bash
$ echo -n d34fda332a0f8997d33db8172b67b1a319fd79d108568aa4fbdb2bpassword | md5sum
156166b575d6074b82f7f6c8453b81b8
```
