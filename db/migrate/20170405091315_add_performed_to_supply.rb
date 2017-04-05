class AddPerformedToSupply < ActiveRecord::Migration[5.0]
  def change
    add_column :supplies, :performed, :boolean
  end
end
