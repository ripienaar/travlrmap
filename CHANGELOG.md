### 1.5.1
  * Upgrade to bootstrap and bootswatch 3.3.4 (#56)
  * Change color of notvisited icon to be more distinctive (#55)

### 1.5.0
  * Upgrade to bootstrap and bootswatch 3.3.2 (#33)
  * Support authentication by another webserver (#49)
  * Ruby 1.9.3 and UTF-8 compatibility
  * Improve geolocate lookups by skipping purely numerical results for place names (#41)
  * Add today button to the calendar (#42)
  * Initial rudementary support for Galleries (#47)
  * Use map icons from http://mapicons.nicolasmollet.com/ to spruce things up a bit (#52)
  * Use new icons and default marker cluster style by default (#52)
  * Allow types to be hidden on the legend, useful for types like galleries (#47)

### 1.4.0
  * Avoid double titles in Google Earth by not putting the title in the html (#29)
  * Show the correct error message when a point failed to save (#29)
  * General refactoring from single sinatra file to a few utility classes (#29)
  * Better handling of domains without linktext (#29)
  * Support bootswatch themes (#34)
  * Support for Ruby 1.8.7 has been removed
  * Fix problems building the gem on modern rubygems (#37)

### 1.3.0
  * Improve mobile rendering of the geocoder and support geocoding current position (#5)
  * Show :linkimg: and :linktext: even when no :href: is set (#21)
  * Show the domain a link points to instead of 'link' when no :linktext: is set (#24)
  * Do not reset the date field after every geocode (#22)
  * Improve name picking in the geocoder (#27)

#### 1.2.0
  * Autoselect the yaml text in the geocoder preview when clicked on (#17)
  * Support saving points (#1)

#### 1.1.0
  * Support various 3rd party tile sets (#13)
  * Support map sets (#14)
  * Support loading points from a direcotry (#14)

#### 1.0.0
  * Support tracking visits using Google Analytics (#10)
  * Instead of forcing full page reloads to change view use javascript when possible (#6)
  * Add an /about page (#9)
  * Add github pages based documentation at https://ripienaar.github.io/travlrmap/ (#8)

#### 0.0.18
  * Auto close the date picker once a day has been selected (#3)
  * Add a clear button to the date picker (#4)
  * Do not highlight today (#4)
  * Optionally authenticate /geocode and /points/validate (#2)

#### 0.0.17
  * Do not set empty point values to empty string and simplify point html creation as a result
  * Add a datepicker to the geocoder to make entering dates easier
  * Autofocus the search bar in the geocoder

#### 0.0.16
  * Remove some debugging

#### 0.0.15
  * Add /geocode url end point to assist in making points
  * Remove the old ruby script for making points

