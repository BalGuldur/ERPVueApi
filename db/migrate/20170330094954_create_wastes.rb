class CreateWastes < ActiveRecord::Migration[5.0]
  def change
    create_table :wastes do |t|
      t.float :summ

      t.timestamps
    end
  end
end
