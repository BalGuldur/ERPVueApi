class AddClientToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :client, :string
  end
end
