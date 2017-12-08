class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :surname
      t.string :fullname
      t.json :phones
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :clients, :deleted_at
  end
end
