class AddSummCatererToSupply < ActiveRecord::Migration[5.0]
  def change
    add_column :supplies, :summ, :float
    add_column :supplies, :caterer, :string
  end
end
