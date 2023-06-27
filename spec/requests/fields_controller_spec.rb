require 'rails_helper'

def wrap_into_geojson_polygon(data)
  {
    "type": "Feature",
    "properties": {},
    "geometry": {
        "type": "Polygon",
        "coordinates": [data]
    }
  }
end

describe 'POST /fields', type: :request do
  let(:polygon_1) do
    [
      [
          -74.858643,
          41.844722
      ],
      [
          -75.072876,
          41.256585
      ],
      [
          -74.331299,
          41.314401
      ],
      [
          -74.858643,
          41.844722
      ]
    ]
  end

  let(:polygon_2) do
    [
      [
          -73.963257,
          40.558801
      ],
      [
          -73.194214,
          40.625574
      ],
      [
          -73.622681,
          40.156766
      ],
      [
          -73.963257,
          40.558801
      ]
   ]
  end

  let(:result_multipolygon) do
    {
      "type": "MultiPolygon",
      "coordinates": [
        [polygon_1],
        [polygon_2]
      ]
    }
  end

  let(:name) { 'New Field' }

  let(:params) do
    {
      "polygons": [
          wrap_into_geojson_polygon(polygon_1),
          wrap_into_geojson_polygon(polygon_2)
      ],
      "name": name
  }
  end

  let(:precalculated_area) { 6208496762.301932 }

  subject do
    post '/fields', params: params.to_json, headers: { 'Content-Type': 'application/json' }
  end

  it 'creates a new field with requested params' do
    subject
    response_json = JSON.parse(response.body)
    new_field = Field.find(response_json['id'])
    expect(new_field).to be_present
    expect(new_field.name).to eq(name)
    expect(new_field.area).to eq(precalculated_area)
    expect(RGeo::GeoJSON.encode(new_field.shape)).to eq(result_multipolygon.with_indifferent_access)
  end
end
