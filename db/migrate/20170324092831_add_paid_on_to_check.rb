class AddPaidOnToCheck < ActiveRecord::Migration[5.0]
  def change
    add_column :checks, :paidOn, :datetime
  end
end
