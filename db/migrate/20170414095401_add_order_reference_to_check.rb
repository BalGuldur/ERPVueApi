class AddOrderReferenceToCheck < ActiveRecord::Migration[5.0]
  def change
    add_reference :checks, :order, foreign_key: true
  end
end
