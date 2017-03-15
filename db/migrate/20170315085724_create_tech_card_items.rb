class CreateTechCardItems < ActiveRecord::Migration[5.0]
  def change
    create_table :tech_card_items do |t|
      t.float :qty
      t.references :ingredient, foreign_key: true
      t.references :tech_card, foreign_key: true

      t.timestamps
    end
  end
end
