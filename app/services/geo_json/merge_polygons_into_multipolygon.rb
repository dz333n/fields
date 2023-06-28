module GeoJson
  class MergePolygonsIntoMultipolygon
    attr_reader :features

    def initialize(features)
      @features = features
    end

    def call
      multipolygon = {
         'type' => 'MultiPolygon',
         'coordinates' => polygons_coordinates + multi_polygons_coordinates
      }

      if multipolygon['coordinates'].empty?
        raise ArgumentError, "The result multipolygon is empty"
      end

      RGeo::GeoJSON.decode(multipolygon)
    end

    def polygons_coordinates
      coordinates_of('Polygon')
    end

    def multi_polygons_coordinates
      coordinates_of('MultiPolygon').flatten(1)
    end

    def coordinates_of(geometry_type)
      features
        .select { |feature| feature['geometry']['type'] == geometry_type }
        .map { |polygon| polygon['geometry']['coordinates'] }
    end
  end
end
