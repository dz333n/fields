module Fields
  class Update
    attr_reader :field, :name, :polygons

    def initialize(name:, polygons:, field:)
      @name = name
      @polygons = polygons
      @field = field
    end

    def call
      if polygons_were_edited?
        multipolygon = convert_polygons
        area = ::GeoJson::CalculateArea.new(RGeo::GeoJSON.encode(multipolygon)).call
      else
        multipolygon = field.shape
        area = field.area
      end

      field.update!(
        name: name,
        shape: multipolygon,
        area: area
      )
    end

    def convert_polygons
      ::GeoJson::PolygonsToMultipolygon.new(polygons).call
    end

    def polygons_were_edited?
      polygons.present?
    end
  end
end
