---
layout: page
title: "Testing locally"
category: doc
date: 2015-01-10 11:37:43
order: 1
---

You'd usually [host on Heroku](http://ripienaar.github.io/travlrmap/doc/setting-up-on-heroku.html) but when first getting the hang of things it's handy to test locally, especially while making look and feel changes or testing a new release of the Gem.

To get this going follow the Heroku process and make your ```GemFile```, ```Gemfile.lock```, ```config.ru``` and config files.  Then simply run  the following:

If you've made changes like require a new version of the travlrmap Gem you need to update the bundle:

```bash
$ bundle update
Fetching gem metadata from http://rubygems.org/...........
Using builder (3.2.2)
Using bundler (1.2.1)
Using gli (2.12.2)
Using multi_json (1.10.1)
Using multi_xml (0.5.5)
Using httparty (0.11.0)
Using json (1.8.2)
Using nokogiri (1.5.2)
Using rack (1.5.2)
Using rack-protection (1.5.3)
Using ruby_kml (0.1.7)
Using tilt (1.4.1)
Using sinatra (1.4.5)
Using travlrmap (1.0.0)
Your bundle is updated! Use `bundle show [gemname]` to see where a bundled gem is installed.
```

After that run:

```bash
$ bundle exec rackup
[2015-01-10 11:41:53] INFO  WEBrick 1.3.1
[2015-01-10 11:41:53] INFO  ruby 1.8.7 (2013-06-27) [x86_64-linux]
[2015-01-10 11:41:53] INFO  WEBrick::HTTPServer#start: pid=1648 port=9292
```

Now browse to your host port ```9292``` and you should see your local copy running.  The ```bundle update``` step is only needed if you changed your Gemfile or the first time.
