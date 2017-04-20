class AddPrintJobIdsToCheck < ActiveRecord::Migration[5.0]
  def change
    add_column :checks, :print_job_ids, :text
  end
end
