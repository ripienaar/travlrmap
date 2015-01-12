---
layout: page
title: "Config - Enable saving"
category: ref
date: 2015-01-12 19:35:05
order: 4
---

As of version ```1.2.0``` you can enable saving of data files to a specific data file under ```config```

To enable this you have to first enable authentication, saving is not supported without authentication.

You then have to designate a file as the incoming data file:

```YAML
  :save_to: travels/incoming
```

To then enable writing you have to create a file ```config/travels/incoming.yaml``` with the following content:

```YAML
---
:points: []
```

Now when you go to the geocoder you should see a ```save``` button, new points will be saved into this file.  If you save the same point twice the old one gets updated.
