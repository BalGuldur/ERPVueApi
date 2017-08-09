class CreateHalls < ActiveRecord::Migration[5.0]
  def change
    create_table :halls do |t|
      t.string :title
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :halls, :deleted_at
  end
end
