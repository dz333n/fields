require 'rails_helper'

RSpec.describe Fields::MergeFields do
  describe '#call' do
    let(:field1) { double('Field', shape: geometry1, id: 1) }
    let(:field2) { double('Field', shape: geometry2, id: 2) }
    let(:fields) { [field1, field2] }
    let(:geometry1) { double('Geometry1') }
    let(:geometry2) { double('Geometry2') }
    let(:feature1) { double('Feature1') }
    let(:feature2) { double('Feature2') }
    let(:feature_collection) { double('FeatureCollection') }
    let(:geojson) { double('GeoJSON') }

    subject { described_class.new(fields: fields).call }

    before do
      allow(RGeo::GeoJSON::Feature).to receive(:new).with(geometry1, 1, {}).and_return(feature1)
      allow(RGeo::GeoJSON::Feature).to receive(:new).with(geometry2, 2, {}).and_return(feature2)
      allow(RGeo::GeoJSON::FeatureCollection).to receive(:new).with([feature1, feature2]).and_return(feature_collection)
      allow(RGeo::GeoJSON).to receive(:encode).with(feature_collection).and_return(geojson)
    end

    it 'returns the merged GeoJSON' do
      expect(subject).to eq(geojson)
    end

    it 'creates features with correct geometry and IDs' do
      expect(RGeo::GeoJSON::Feature).to receive(:new).with(geometry1, 1, {})
      expect(RGeo::GeoJSON::Feature).to receive(:new).with(geometry2, 2, {})
      subject
    end

    it 'creates a feature collection with the generated features' do
      expect(RGeo::GeoJSON::FeatureCollection).to receive(:new).with([feature1, feature2])
      subject
    end

    it 'encodes the feature collection into GeoJSON' do
      expect(RGeo::GeoJSON).to receive(:encode).with(feature_collection)
      subject
    end
  end
end
