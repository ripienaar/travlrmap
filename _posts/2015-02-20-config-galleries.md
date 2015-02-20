---
layout: page
title: "Config - Galleries"
category: ref
date: 2015-02-20 20:22:47
disqus: 1
---

As of version 1.5.0 galleries are implemented using a special kind of point using
the ```:type: :gallery```.

The gallery system will be pluggable in time and hopefully support rendering them in the
app without needing to leave it but as it is today it is quite limited - it opens a
new tab to flickr's slide show feature.

To use galleries you must first have a type ```:gallery```:

```yaml
:types:
  :gallery:
    :icon: /mapicons/stores/photography.png
    :description: Gallery
    :legend: false
```

Setting ```:legend``` to false here avoid this type showing up in the overall legend below the map.

You can now create a gallery point like this:

```yaml
- :title: Holiday February 2015
  :comment: Gallery of photos taken on holiday early 2015
  :country: Spain
  :linktext: East Coast Road Trip
  :linkimg: https://farm8.staticflickr.com/7387/16331224608_f36063b0cd_m_d.jpg
  :lon: -4
  :lat: 39
  :type: :gallery
  :gallery: flickr,user=ripienaar,set=72157648567428473
```

As you can see it's a normal point, the only interesting things are the ```:type: :gallery``` and
the ```:gallery: flickr,user=ripienaar,set=72157648567428473```

It won't make sense to use ```:href:``` with gallery images and likewise ```:gallery:``` with non
```:gallery``` type points.

At present the only gallery type supported is Flickr, simply browse to one of your albums and grab
the set id from the URL.

More types will be supported in future.
