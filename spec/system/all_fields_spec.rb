require 'rails_helper'

RSpec.describe 'All Fields', type: :system do
  let(:mocked_geojson) { {'type': 'FeatureCollection', 'features': []} } 
  let!(:fields) do 
    3.times.map do |_|
      create(:field)
    end
  end

  subject do
    visit '/fields'
  end

  before do
    merge_fields_service = instance_double('Fields::MergeFields')
    allow(Fields::MergeFields).to receive(:new).and_return(merge_fields_service)
    allow(merge_fields_service).to receive(:call).and_return(mocked_geojson)
  end

  it 'shows the available fields' do
    subject
    fields.each do |field|
      element = find("[data-test-field-id='#{field.id}']")
      expect(element).to be_present
    end
  end

  it 'shows the map with all fields merged' do
    subject
    element = find("[data-controller='maps']")
    data_tag_value = element['data-maps-geo-json']
    puts({data_tag_value: data_tag_value})
    expect(data_tag_value).to eq(mocked_geojson.to_json) 
  end

  context 'when there are no fields' do
    let!(:fields) { [] }

    it 'shows the no fields tip' do
      subject
      expect(page).to have_content('There are no fields yet.')
    end
  end
end
