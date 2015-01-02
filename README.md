What?
=====

A web application that can be used to show where you have traveled to - or any
other locations really.  It's not a check-in style app more a means of tracking
city or attraction level places you're been to.

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

Setup?
------

The app is distributed as a [rubygem](https://rubygems.org/gems/travlrmap) and runs
inside a ruby app server.

There is a demo of a fully working setup that runs on Heroku, it's on github and
can be seen [here](https://github.com/ripienaar/travlrmap-demo).

You only need to copy the *Gemfile* and *config.ru* files from there into a new
directory.  Create *config* and *images* directories and copy the sample config
files into the config directory removing the *.dist* extension.

You need to have bundler installed, a heroku account and the heroku toolkit
installed.

```
$ heroku create
Creating polar-harbor-2295... done, stack is cedar-14
https://polar-harbor-2295.herokuapp.com/ | https://git.heroku.com/polar-harbor-2295.git
Git remote heroku added
```

Take a note of the URL this shows.  Edit the *travlrmap.yaml* and fix the paths
for the types of visit.

Now create the *Gemfile.lock*

```
$ bundle update
.
.
Your bundle is updated! Use `bundle show [gemname]` to see where a bundled gem is installed.
```

Check in everything into git and do ```git push heroku master``` when it's one your
app should be up and running and accessible.

Commit your files to your own git repo and start adding points.

Important to note if you change add points or types etc it will take up to 6 minutes for
them to be visible.  Google will fetch the KML data and cache it for a while so updates
are not immediate.

Config Reference?
-----------------

A sample config file can be seen in *config/travlrmap.yaml.dist*, it shows all
possible configuration options and samples of each:

### :map: Section

Basic overvall settings controlling data sources and the look of the site

#### :data:
Where to load data from.

Data can be stored in one or multiple files, just list your yaml files in an array
here

#### :width:
Map width.  The map gets rendered into a div on the page, this controls how much of
that div is taken up by the map, as the div is 100% wide this is a good way to
keep some relative sized whitespace around.

#### :height:
Map height.  As above for :width:

#### :zoom_control:, :map_type_control:, :street_view_control:, :overview_control:, :pan_control:
These settings enable and disable parts of the Google maps UI

#### :title:
The title to show top of the page

### :views: Section

Custom views to show pre-decided parts of your map.  You should configure at least
one called *:default:*, the one in the sample data shows the world

All settings as per the sample is required.  You can get the lon/lat/zoom by simply
browsing to google maps and looking at the URL.

### :types: Section

This defines type of visit, you can reference these later when creating points.

The sample data sets up 3 types, the url in :icon: has to be a full URL and not a
relative URL, this is because Google fetches these and not your browser.

A number of markers are included already for you to use, you can see them [here](https://github.com/ripienaar/travlrmap/tree/master/public/markers).

Contact?
--------

R.I.Pienaar / rip@devco.net / @ripienaar / http://devco.net/
