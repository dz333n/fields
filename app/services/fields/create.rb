module Fields
  class Create
    attr_reader :name, :polygons

    def initialize(name:, polygons:)
      @name = name
      @polygons = polygons
    end

    def call
      multipolygon = ::GeoJson::PolygonsToMultipolygon.new(polygons).call
      area = ::GeoJson::CalculateArea.new(RGeo::GeoJSON.encode(multipolygon)).call

      Field.create!(
        name: name,
        shape: multipolygon,
        area: area
      )
    end
  end
end
