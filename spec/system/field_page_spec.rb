require 'rails_helper'

RSpec.describe 'Field Page', type: :system do
  let(:mocked_geojson) { {'type': 'FeatureCollection', 'features': []} } 
  let(:field) { create(:field) }

  subject do
    visit "/fields/#{field.id}"
  end

  before do
    allow(RGeo::GeoJSON).to receive(:encode).and_return(mocked_geojson)
  end

  it 'shows the field information' do
    subject
    expect(find('h3')['innerHTML']).to eq(field.name)
    expect(find('pre')['innerHTML']).to eq(JSON.pretty_generate(mocked_geojson))
    expect(page).to have_content("#{field.area} m²")
    
    map_element = find("[data-controller='maps']")
    data_tag_value = map_element['data-maps-geo-json']
    expect(data_tag_value).to eq(mocked_geojson.to_json) 
  end
end
