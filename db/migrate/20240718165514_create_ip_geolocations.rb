class CreateIpGeolocations < ActiveRecord::Migration[7.1]
  def change
    create_table :ip_geolocations do |t|
      t.string :ip_address, index: { unique: true }
      t.json :data
      t.timestamps
    end
  end
end
