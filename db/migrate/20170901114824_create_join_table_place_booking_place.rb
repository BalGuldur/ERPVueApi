class CreateJoinTablePlaceBookingPlace < ActiveRecord::Migration[5.0]
  def change
    create_join_table :places, :booking_places do |t|
      t.index [:place_id, :booking_place_id]
      t.index [:booking_place_id, :place_id]
    end
  end
end
