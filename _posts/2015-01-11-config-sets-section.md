---
layout: page
title: "Config - Sets section"
category: ref
date: 2015-01-11 16:40:03
order: 3
---

Data sets allow you to create additional groups of points - imagine your main set of points is places you've been to but you'd also like to track places you'd like to travel, a data set can be created for that and viewed seperately.

The points used in data sets are the same normal, you define sets in your config file:

```YAML
:sets:
  :visited:
    :description: Visited
    :data: travels
  :wishlist:
    :description: Travel Wishlist
    :data: wishlist
```

This sets up 2 sets with data in ```config/travels/*.yaml``` and ```config/wishlist/*.yaml```
