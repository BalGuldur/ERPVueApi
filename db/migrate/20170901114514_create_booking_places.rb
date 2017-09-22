class CreateBookingPlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :booking_places do |t|
      t.datetime :openTime
      t.datetime :closeTime
      t.integer :countGuests
      t.string :name
      t.string :phone
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :booking_places, :deleted_at
  end
end
