---
layout: page
title: "Point Reference"
category: ref
date: 2015-01-09 18:10:54
---

Points are stored in YAML files, here's a sample of a file with 1 point in it:

```yaml
---
:points:
- :type: :visit
  :lon: -71.046524
  :lat: 42.363871
  :title: Boston
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

### Reference

Today these are the significant fields but you're welcome to add more if you'd like to track some additional information about a point.  The site will just ignore these additional fields but if you do add more it's best to name them like ```_your_item``` to avoid future issues if the site does get more features, we'll never use keys that start with a ```_``` for our needs.

Key        |Description
-----------|-----------
:type:     | The visit type, has to match one defined in the config file, leading ```:``` is important.
:lon:      | The longitude
:lat:      | The Latitude
:title:    | Short title of the point
:country:  | Which country it is in
:comment:  | A comment for your point which may include basic HTML like bolding etc
:href:     | An optional link to further information to associate with the point
:linkimg:  | An optional image to show instead of the default placeholder text for the href
:linktext: | Optional text to use for the link, can combine with the image
:date:     | The date of this visit, dddd-mm-yy format


### Format conversions

You can browse to ```/points/kml``` and ```/points/json``` to get these points returned in either KML or JSON formats for processing into other tools.

