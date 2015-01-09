---
layout: page
title: "Point Reference"
category: doc
date: 2015-01-09 18:10:54
---

Points are stored in YAML files, here's a sample of a file with 1 point in it:

```yaml
---
:points:
- :type: :visit
  :lon: -71.046524
  :title: Boston
  :lat: 42.363871
  :country: United States
  :comment: Sample Data
  :href: http://en.wikipedia.org/wiki/Boston
  :linkimg: https://pbs.twimg.com/profile_images/430836891198320640/_-25bnPr.jpeg
  :linktext: Wikipedia
  :date: 2013-03-28
```

You can create these by hand but the easiest is to use the included geocoder which is available on ```/geocode``` on your instance.

The geocoder supports simple searches or you can right click anywhere on the map.  It will fill in some information about the place gathered from Googles API, give you a chance to pick the type of visit and fill in various fields.

Press ```Preview``` and the popup will show you how your point will look when clicked as well as the YAML ready to paste into the points file.
