class Waste < ApplicationRecord
  has_many :waste_items, dependent: :destroy
  has_many :store_items, through: :waste_items

  def self.front_view_with_name_key
    f_v = {}
    all.each do |waste|
      f_v.merge!(waste.front_view_with_key)
    end
    {wastes: f_v}
  end

  def self.front_view
    f_v = {}
    all.each do |waste|
      f_v.merge!(waste.front_view_with_key)
    end
    f_v
  end

  def front_view_with_name_key
    {waste: front_view_with_key}
  end

  def front_view_with_key
    {id => front_view}
  end

  def front_view_with_name
    {waste: front_view}
  end

  def front_view
    as_json(methods: [:waste_item_ids])
  end

  def waste_store
    # puts "store item ids #{self.store_item_ids}"
    waste_items.each do |waste_item|
      @store_item = waste_item.store_item
      @store_item.remains = @store_item.remains - waste_item.qty
      @store_item.save
    end
  end

  def revert
    revert_store
    if destroy
      self
    else
      waste_store
      false
    end
  end

  def revert_store
    waste_items.each do |waste_item|
      @store_item = waste_item.store_item
      @store_item.remains = @store_item.remains + waste_item.qty
      @store_item.save
    end
  end
end
