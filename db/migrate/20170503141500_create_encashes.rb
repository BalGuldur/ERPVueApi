class CreateEncashes < ActiveRecord::Migration[5.0]
  def change
    create_table :encashes do |t|
      t.float :cash

      t.timestamps
    end
  end
end
