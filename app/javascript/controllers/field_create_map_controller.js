import { Controller } from "@hotwired/stimulus";
import L from "leaflet";
import "@geoman-io/leaflet-geoman-free";

// Connects to data-controller="edit"
export default class extends Controller {
  static targets = ["container"];

  connect() {
    this.map = L.map(this.containerTarget);
    this.map.setView(new L.LatLng(40.737, -73.923), 8);

    L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
      maxZoom: 19,
      attribution:
        '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
    }).addTo(this.map);

    this.map.pm.addControls({
      position: "topleft",
      drawCircle: false,
      drawMarker: false,
      drawCircleMarker: false,
      drawPolyline: false,
      drawRectangle: false,
      drawText: false,
    });

    const form = document.getElementById("create-field-form");
    form.addEventListener("submit", this.handleSubmit.bind(this));
  }

  handleSubmit(event) {
    event.preventDefault();
    this.hideError();
    this.setFormDisabled(true);

    const layers = this.map.pm.getGeomanDrawLayers();
    if (layers.length === 0) {
      this.showError("There are no layers drawn on the map!");
      return;
    }

    const polygons = layers.map((layer) => layer.toGeoJSON());

    fetch("/fields", {
      method: "POST",
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
    const form = document.getElementById("create-field-form");
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
