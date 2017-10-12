class AddObjectIdToCashBoxLog < ActiveRecord::Migration[5.0]
  def change
    add_column :cash_box_logs, :object_id, :integer
  end
end
