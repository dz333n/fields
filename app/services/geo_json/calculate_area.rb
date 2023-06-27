module GeoJson
  class CalculateArea
    attr_reader :multipolygon

    def initialize(multipolygon)
      @multipolygon = multipolygon
    end

    def call
      object = RGeo::GeoJSON.decode(multipolygon, geo_factory: RGeo::Geographic.simple_mercator_factory)
      object.area
    end
  end
end
