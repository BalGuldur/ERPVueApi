class AddNotPaidToShift < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :purchaseSumm, :float
    add_column :shifts, :notPaidStaffSumm, :float
    add_column :shifts, :notPaidClientsSumm, :float
  end
end
