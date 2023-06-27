module GeoJson
  class PolygonsToMultipolygon
    attr_reader :polygons

    def initialize(polygons)
      @polygons = polygons
    end

    def call
      coordinates = polygons.map { |polygon| polygon['geometry']['coordinates'] }

      multipolygon = {
         'type' => 'MultiPolygon',
         'coordinates' => coordinates
      }

      RGeo::GeoJSON.decode(multipolygon)
    end
  end
end
