class AddOpenPlaceReferencesToOrder < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :open_place, foreign_key: true
  end
end
