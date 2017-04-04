class SupplyItem < ApplicationRecord
  before_create :fix_store

  belongs_to :supply
  belongs_to :ingredient
  has_one :store_item, through: :ingredient

  private

  def fix_store
    if ingredient.store_item.present?
      oldQty = ingredient.store_item.remains
      newQty = qty + oldQty
      oldPrice = ingredient.store_item.price
      ingredient.store_item.price = (((oldPrice * oldQty) + summ) / newQty).round(2)
      ingredient.store_item.remains = newQty.round(4)
      ingredient.store_item.save
    else
      ingredient.store_item = StoreItem.new(price: (summ / qty), remains: qty)
    end
  end
end
