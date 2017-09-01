class CreateOpenPlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :open_places do |t|
      t.integer :countGuests
      t.string :name
      t.string :phone
      t.datetime :openTime
      t.datetime :closeTime
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :open_places, :deleted_at
  end
end
