class AddNameToTechCard < ActiveRecord::Migration[5.0]
  def change
    add_column :tech_cards, :name, :string
  end
end
