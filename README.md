What?
=====

Work in progress app to show case my travels.  It's not a check-in style app
more a means of tracking city or attraction level places you're been to.

It's not social, does not have a database or app to check-in with, you maintain
data files in YAML that gets rendered on a map.

```
---
:points:
- :type: :visit
  :lon: -73.961334
  :title: New York
  :lat: 40.784506
  :country: United States
  :comment: Sample Data
  :href: http://en.wikipedia.org/wiki/New_York
  :linktext: Wikipedia
- :type: :visit
  :lon: -71.046524
  :title: Boston
  :lat: 42.363871
  :country: United States
  :comment: Sample Data
  :href: http://en.wikipedia.org/wiki/Boston
  :linkimg: https://pbs.twimg.com/profile_images/430836891198320640/_-25bnPr.jpeg
```

Here you can see 2 places being defined including links, images and so forth.

It's not done, you can see it in action on my own site: http://travels.devco.net

More details including deployment guide to follow.
