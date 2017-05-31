class AddShiftReferencesToCheck < ActiveRecord::Migration[5.0]
  def change
    add_reference :checks, :shift, foreign_key: true
  end
end
