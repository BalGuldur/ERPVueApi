class AddPlaceClientToCheck < ActiveRecord::Migration[5.0]
  def change
    add_column :checks, :placeTitle, :string
  end
end
