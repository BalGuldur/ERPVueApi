class AddPlaceTitleToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :placeTitle, :string
  end
end
