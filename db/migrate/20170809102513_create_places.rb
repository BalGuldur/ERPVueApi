class CreatePlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :places do |t|
      t.string :title
      t.integer :capacity
      t.datetime :deleted_at
      t.references :hall, foreign_key: true

      t.timestamps
    end
    add_index :places, :deleted_at
  end
end
