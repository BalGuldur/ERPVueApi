class AddOpenPlaceReferencesToPlace < ActiveRecord::Migration[5.0]
  def change
    add_reference :places, :open_place, foreign_key: true
  end
end
