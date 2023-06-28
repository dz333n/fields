import { Controller } from "@hotwired/stimulus";
import L from "leaflet";
import { centerMap, createMap } from "../utils";

// Connects to data-controller="maps"
export default class extends Controller {
  static targets = ["container"];

  connect() {
    this.map = createMap(this.containerTarget);

    const geoJsonString = this.data.get("geoJson");
    const geoJson = JSON.parse(geoJsonString);
    const geoJsonOnMap = L.geoJson(geoJson).addTo(this.map);

    const objectsCount =
      geoJson.coordinates?.length || geoJson.features?.length || 0;
    if (objectsCount >= 1) {
      this.map.fitBounds(geoJsonOnMap.getBounds());
    } else {
      centerMap(this.map);
    }
  }

  disconnect() {
    this.map.remove();
  }
}
