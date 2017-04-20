class AddSummToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :summ, :float
  end
end
