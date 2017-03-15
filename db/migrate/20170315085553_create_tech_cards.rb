class CreateTechCards < ActiveRecord::Migration[5.0]
  def change
    create_table :tech_cards do |t|
      t.string :title
      t.float :price

      t.timestamps
    end
  end
end
