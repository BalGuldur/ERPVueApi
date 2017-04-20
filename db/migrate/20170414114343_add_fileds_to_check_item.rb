class AddFiledsToCheckItem < ActiveRecord::Migration[5.0]
  def change
    add_column :check_items, :summ, :float
    add_column :check_items, :techCardPrice, :float
    add_column :check_items, :techCardTitle, :string
  end
end
