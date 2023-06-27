import { Controller } from "@hotwired/stimulus"
import L from "leaflet"

// Connects to data-controller="maps"
export default class extends Controller {
  static targets = ["container"]

  connect() {
    const geoJsonString = this.data.get('geoJson');
    const geoJson = JSON.parse(geoJsonString);

    this.map = L.map(this.containerTarget);

    L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(this.map);

    const geoJsonOnMap = L.geoJson(geoJson).addTo(this.map);
    this.map.fitBounds(geoJsonOnMap.getBounds());
  }

  disconnect() {
    this.map.remove();
  }
}