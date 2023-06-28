module Fields
  class Update
    attr_reader :field, :name, :polygons

    def initialize(name:, polygons:, field:)
      @name = name
      @polygons = polygons
      @field = field
    end

    def call
      multipolygon = polygons_were_edited? ? convert_polygons : original_shape

      area = ::GeoJson::CalculateArea.new(RGeo::GeoJSON.encode(multipolygon)).call

      field.update!(
        name: name,
        shape: multipolygon,
        area: area
      )
    end
    
    def original_shape
      field.shape
    end

    def convert_polygons
      ::GeoJson::PolygonsToMultipolygon.new(polygons).call
    end

    def polygons_were_edited?
      polygons.present?
    end
  end
end
