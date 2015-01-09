---
layout: page
title: "Setting up"
category: doc
date: 2015-01-09 17:50:11
---

The app is distributed as a [RubyGem](http://rubygems.org/gems/travlrmap) so to host your own either on a PaaS or locally you only need config file, points and a ```Gemfile```.

The files for a fully functional [demo instance](https://github.com/ripienaar/travlrmap-demo) of the site can be seen [at gitHub](https://github.com/ripienaar/travlrmap-demo), this demo site is hosted at Heroku on their free single dynamo option.

Below are basic details to get going, but you can just clone the ```ripienaar/travlrmap-demo``` repo to your own GitHub account and start adding points.  As it's there it works out the box with Heroku.

if you choose to make the files below, just check them all in to git and either hook Heroku up to your GitHub or use their Git based deploy process.

### Create a ```Gemfile``` and ```Gemfile.lock```

The Gemfile just lists ```travlrmap``` as a dependency:

```ruby
source 'http://rubygems.org'

gem 'travlrmap', '0.0.17'
```

Now run bunlder to create the ```Gemfile.lock```

```bash
$ bundle update
Fetching gem metadata from http://rubygems.org/...........
Using builder (3.2.2)
Using bundler (1.2.1)
Using gli (2.12.2)
Using multi_json (1.10.1)
Using multi_xml (0.5.5)
Using httparty (0.11.0)
Using nokogiri (1.5.2)
Using rack (1.5.2)
Using rack-protection (1.5.3)
Using ruby_kml (0.1.7)
Using tilt (1.4.1)
Using sinatra (1.4.5)
Using travlrmap (0.0.17)
Your bundle is updated! Use `bundle show [gemname]` to see where a bundled gem is installed.
```

### Create a ```config.ru```

The ```config.ru``` is the main ruby file that the webserver reads, you can use the one here without any modification:

```ruby
Bundler.require(:default)

set :run, false

APPROOT = File.dirname(__FILE__)
config = YAML.load_file(File.join(APPROOT, "config", "travlrmap.yaml"))

run Travlrmap::SinatraApp.new(config)
```

### Create config files and points

In the main GitHub repo you'll find [some config files](https://github.com/ripienaar/travlrmap/tree/master/config) copy them to your project in a directory named ```config``` and rename them all to end in ```.yaml```.

You can edit the ```travlrmap.yaml``` but generally it shoulld get you something up and running as is.

Points are in YAML files referenced from the ```travlrmap.yaml``` file, the demo includes 2 point files with a few functional points to work from.

### Images

If you have any images you wish to store here like thumbnails for use in points when creating links to Flickr or somewhere you can make a directory called ```images``` but this is optional.


