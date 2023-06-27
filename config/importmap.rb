# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "leaflet", to: "https://ga.jspm.io/npm:leaflet@1.9.4/dist/leaflet-src.js"
pin "leaflet-geosearch", to: "https://ga.jspm.io/npm:leaflet-geosearch@3.8.0/dist/geosearch.module.js"
pin "@geoman-io/leaflet-geoman-free", to: "https://cdn.jsdelivr.net/npm/@geoman-io/leaflet-geoman-free@2.14.2/dist/leaflet-geoman.min.js"
