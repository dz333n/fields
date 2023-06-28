import { Controller } from "@hotwired/stimulus";
import L from "leaflet";
import "@geoman-io/leaflet-geoman-free";
import { createMap, enableDrawing } from "../utils";

// Connects to data-controller="edit"
export default class extends Controller {
  static targets = ["container"];

  connect() {
    this.map = createMap(this.containerTarget);

    const geoJsonString = this.data.get("geoJson");
    const geoJson = JSON.parse(geoJsonString);
    const geoJsonOnMap = L.geoJson(geoJson).addTo(this.map);

    this.map.fitBounds(geoJsonOnMap.getBounds());

    enableDrawing(this.map);

    const form = document.getElementById("edit-field-form");
    form.addEventListener("submit", this.handleSubmit.bind(this));
  }

  handleSubmit(event) {
    event.preventDefault();
    this.hideError();
    this.setFormDisabled(true);

    const layers = this.map.pm.getGeomanDrawLayers();

    const polygons = layers.map((layer) => layer.toGeoJSON());
    const fieldId = this.data.get("id");

    fetch(`/fields/${fieldId}`, {
      method: "PUT",
      body: JSON.stringify({
        polygons,
        name: document.getElementById("field_name").value,
      }),
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then(async (response) => {
        const json = await response.json();

        if (!response.ok) {
          this.showError(json.error || "Something went really wrong");
        } else {
          window.location.href = `/fields/${json.id}`;
        }
      })
      .finally(() => {
        this.setFormDisabled(false);
      });
  }

  disconnect() {
    this.map.remove();
  }

  setFormDisabled(disabled) {
    const form = document.getElementById("edit-field-form");
    form.disabled = disabled;
  }

  showError(text) {
    const alert = document.getElementsByClassName("alert-danger")[0];
    alert.classList.remove("d-none");
    alert.innerHTML = text;
  }

  hideError() {
    document.getElementsByClassName("alert-danger")[0].classList.add("d-none");
  }
}
