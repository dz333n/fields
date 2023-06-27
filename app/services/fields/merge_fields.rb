module Fields
  class MergeFields
    attr_reader :fields

    def initialize(fields:)
      @fields = fields
    end

    def call
      features = fields.map do |field|
        geometry = field.shape
        RGeo::GeoJSON::Feature.new(geometry, field.id, {})
      end

      feature_collection = RGeo::GeoJSON::FeatureCollection.new(features)

      RGeo::GeoJSON.encode(feature_collection)
    end
  end
end
