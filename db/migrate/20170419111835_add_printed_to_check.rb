class AddPrintedToCheck < ActiveRecord::Migration[5.0]
  def change
    add_column :checks, :printed, :boolean
  end
end
