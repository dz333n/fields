class CreateFields < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'postgis'

    create_table :fields do |t|
      t.string :name
      t.multi_polygon :shape, geographic: true, srid: 4326
      t.float :area

      t.timestamps
    end
  end
end
