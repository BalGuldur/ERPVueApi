class CreateShifts < ActiveRecord::Migration[5.0]
  def change
    create_table :shifts do |t|
      t.string :employee
      t.datetime :openOn
      t.datetime :closeOn
      t.references :work_day, foreign_key: true

      t.timestamps
    end
  end
end
