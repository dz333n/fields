[![demo gif](demo.gif)](demo.gif)

# Technical Information

This projects lets users to see and manage fields.

### Maps

Leaflet is used for maps renderer. For drawing options using [Leflet-Geoman](https://www.npmjs.com/package/@geoman-io/leaflet-geoman-free#installation) plugin. The plugin is configured so it lets to draw polygons, to make holes in the polygons, to drag the points of the polygon.

### Tests

The projects has pages with simple logic covered with Capybara tests, more complex logic covered with unit tests and some medium-complexity API logic covered with requests tests.

# Project setup

The Docker/docker-compose versions were used to develop this project:

```
> docker --version
Docker version 24.0.2, build cb74dfc

> docker-compose --version
Docker Compose version v2.18.1
```

# Run project locally

1. Run this command:

```bash
docker-compose up
```

2. **Done.** At this point you should be able to access the website locally at http://localhost:3000

# Run tests

```bash
docker-compose run web rspec
```

# ⚠️ Known Issues

- Once running tests, there will be lines like `find: ‘/root/.config/chromium/Crash Reports/pending/’: No such file or directory`. This is due to latest Chromium update and does not affect anything, so ignore it so far.
- The area calculation is concerning, since it's probably very approximate. [Related Stackoverflow discussion](https://stackoverflow.com/questions/67477231/calculating-area-with-rgeo-and-geojson).
