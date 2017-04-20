class AddFieldsToCheck < ActiveRecord::Migration[5.0]
  def change
    add_column :checks, :cashBoxDiscount, :integer
    add_column :checks, :cashBoxTitle, :string
  end
end
