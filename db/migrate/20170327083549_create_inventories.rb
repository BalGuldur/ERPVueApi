class CreateInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :inventories do |t|
      t.datetime :doDate
      t.integer :diffQty
      t.float :diffSumm
      t.string :status

      t.timestamps
    end
  end
end
