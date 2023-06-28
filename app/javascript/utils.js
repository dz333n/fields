import L from "leaflet";

export function centerMap(map) {
  map.setView(new L.LatLng(40.737, -73.923), 2);
}

export function createMap(containerTarget) {
  const map = L.map(containerTarget);

  L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
    maxZoom: 19,
    attribution:
      '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
  }).addTo(map);

  return map;
}

export function enableDrawing(map) {
  map.pm.addControls({
    position: "topleft",
    drawCircle: false,
    drawMarker: false,
    drawCircleMarker: false,
    drawPolyline: false,
    drawRectangle: false,
    drawText: false,
  });
}
