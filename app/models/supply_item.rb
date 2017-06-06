class SupplyItem < ApplicationRecord
  before_create :fix_store

  belongs_to :supply
  belongs_to :ingredient
  has_one :store_item, through: :ingredient

  def self.front_view_with_name_key
    f_v = {}
    all.includes(:supply, :ingredient, :store_item).find_each do |supply_item|
      f_v.merge!(supply_item.front_view_with_key)
    end
    {supplyItems: f_v}
  end

  def self.front_view
    f_v = {}
    all.each do |supply_item|
      f_v.merge!(supply_item.front_view_with_key)
    end
    f_v
  end

  def front_view_with_name_key
    {supplyItem: front_view_with_key}
  end

  def front_view_with_key
    {id => front_view}
  end

  def front_view_with_name
    {wasteItem: front_view}
  end

  def front_view
    as_json(methods: [:supply_id, :ingredient_id, :store_item_id])
  end

  def revert
    if ingredient.present? and ingredient.store_item.present?
      currPrice = ingredient.store_item.price
      currQty = ingredient.store_item.remains
      revertQty = currQty - qty
      @store_item = ingredient.store_item
      revertPrice = @store_item.price - changePrice
      @store_item.price = revertPrice
      @store_item.remains = revertQty.round(4)
      @store_item.save!
      @store_item
    end
  end

  def perform
    if ingredient.store_item.present?
      @store_item = ingredient.store_item
      oldQty = @store_item.remains
      newQty = qty + oldQty
      oldPrice = @store_item.price
      @store_item.price = (((oldPrice * oldQty) + summ) / newQty).round(2)
      @store_item.remains = newQty.round(4)
      self.changePrice = (@store_item.price - oldPrice).round(2)
    else
      @store_item = StoreItem.new(ingredient: ingredient, price: (summ / qty).round(2), remains: qty)
      self.changePrice = (summ / qty).round(2)
    end
    self.save!
    @store_item.save!
  end

  private

  def fix_store
    if ingredient.store_item.present?
      oldQty = ingredient.store_item.remains
      newQty = qty + oldQty
      oldPrice = ingredient.store_item.price
      ingredient.store_item.price = (((oldPrice * oldQty) + summ) / newQty).round(2)
      ingredient.store_item.remains = newQty.round(4)
      self.changePrice = (ingredient.store_item.price - oldPrice).round(2)
      ingredient.store_item.save
    else
      ingredient.store_item = StoreItem.new(price: (summ / qty), remains: qty)
    end
  end
end
