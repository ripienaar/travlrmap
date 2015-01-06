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

Adding points?
--------------

Points are just edited by hand into the YAML files, a little utility exist that can help
that you can get by installing the *travlrmap* gem.

```
$ travlrmap search --comment "Airshow" --type visit "farnborough, uk" --href https://www.flickr.com/photos/ripienaar/tags/farnborough --linktext 'Flickr Photos'
---
- :type: :visit
  :linktext: Flickr Photos
  :country: United Kingdom
  :comment: Airshow
  :lon: -0.752615
  :lat: 51.2868939
  :href: https://www.flickr.com/photos/ripienaar/tags/farnborough
  :title: Farnborough
  :date: 2015-01-30
```

This will use Google to geolocate your place and ouput the YAML for the point. The geolocation
is not awesome but it helps, something better will be made in future. Remove the trailing ```---```.

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

#### :cluster:
Set this to true to enable clustering of points, especially useful if you have many many points

#### :cluster_grid_size:
The size of a grid that gets clustered by the clustering library, adjust this if you find that too
are being combined on the map

#### :cluster_minumum_size:
A specific grid of the cluster must have at least this many items before its clustered, defaults to 2

#### :cluster_zoom_on_click:
Set to false to disable the behavior where a cluster click zooms the map to expand all the items in it

#### :cluster_image_path:, :cluster_image_extension:, :cluster_image_sizes:
You can customize the cluster images being used and a number has been provided in the basic HTML colors.

The urls being loaded are in the form ```:cluster_image_path:N.:cluster_image_extension:``` where ```N``` is a number from 1 to 5.

These images have to be square sized and if you tweak the sizes you should specify the sizes for image 1 to 5 in the array :cluster_image_sizes: as here.

#### :show_geocode_link:
By default a ```geocode``` link is shown in the navbar that takes the user to a page allowing them to make
a new point, this can be disabled using this option

### :views: Section

Custom views to show pre-decided parts of your map.  You should configure at least
one called *:default:*, the one in the sample data shows the world

All settings as per the sample is required.  You can get the lon/lat/zoom by simply
browsing to google maps and looking at the URL.

### :types: Section

This defines type of visit, you can reference these later when creating points.

The sample data sets up 3 types.

A number of markers are included already for you to use, you can see them [here](https://github.com/ripienaar/travlrmap/tree/master/public/markers).
A handy service for creating custom ones on demand can be found at http://www.googlemapsmarkers.com/

Changelog?
----------

### 0.0.15
  * Add /geocode url end point to assist in making points
  * Remove the old ruby script for making points

Contact?
--------

R.I.Pienaar / rip@devco.net / @ripienaar / http://devco.net/
