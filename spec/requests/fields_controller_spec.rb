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

describe '/fields', type: :request do
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

  describe 'PUT /fields/:id' do
    let(:field) { create(:field) }

    subject do
      put "/fields/#{field.id}", params: params.to_json, headers: { 'Content-Type': 'application/json' }
    end

    it 'changes field params' do
      subject
      updated_field = field.reload
      expect(updated_field.name).to eq(name)
      expect(updated_field.area).to eq(precalculated_area)
      expect(RGeo::GeoJSON.encode(updated_field.shape)).to eq(result_multipolygon.with_indifferent_access)
    end

    context 'when polygons are not provided' do
      let(:params) do
        {
          "polygons": [],
          "name": name
        }
      end

      it 'changes field params but keeps old map' do
        subject
        old_area = field.area
        old_shape = field.shape
        updated_field = field.reload
        expect(updated_field.name).to eq(name)
        expect(updated_field.area).to eq(old_area)
        expect(RGeo::GeoJSON.encode(updated_field.shape)).to eq(RGeo::GeoJSON.encode(old_shape))
      end
    end
  end

  describe 'POST /fields' do
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

    context "when leaflat returned a multipolygon" do
      let(:feature) do
        {
          "type": "Feature",
          "geometry": {
              "type": "MultiPolygon",
              "coordinates": [
                  [
                      [
                          [
                              -66.072876,
                              66.618608
                          ],
                          [
                              -65.773053,
                              66.592027
                          ],
                          [
                              -65.883691,
                              66.75506
                          ],
                          [
                              -66.072876,
                              66.618608
                          ]
                      ]
                  ],
                  [
                      [
                          [
                              -65.883691,
                              66.75506
                          ],
                          [
                              -65.396048,
                              66.851579
                          ],
                          [
                              -65.699341,
                              66.887301
                          ],
                          [
                              -65.883691,
                              66.75506
                          ]
                      ]
                  ],
                  [
                      [
                          [
                              -65.773053,
                              66.592027
                          ],
                          [
                              -65.556519,
                              66.572812
                          ],
                          [
                              -65.370345,
                              66.687511
                          ],
                          [
                              -65.773053,
                              66.592027
                          ]
                      ]
                  ],
                  [
                      [
                          [
                              -65.396048,
                              66.851579
                          ],
                          [
                              -65.370345,
                              66.687511
                          ],
                          [
                              -65.150024,
                              66.822563
                          ],
                          [
                              -65.396048,
                              66.851579
                          ]
                      ]
                  ]
              ]
          }
      }
      end
      let(:params) do
        {
          "polygons": [
            feature
          ],
          "name": name
        }
      end
      
      it 'saves it directly into database' do
        subject
        response_json = JSON.parse(response.body)
        new_field = Field.find(response_json['id'])
        expect(new_field).to be_present
        expect(RGeo::GeoJSON.encode(new_field.shape)).to eq(feature[:geometry].with_indifferent_access)
      end
    end
  end
end
