class WasteItem < ApplicationRecord
  belongs_to :waste
  belongs_to :ingredient
  belongs_to :store_item

  def self.front_view_with_name_key
    f_v = {}
    all.each do |waste_item|
      f_v.merge!(waste_item.front_view_with_key)
    end
    {wasteItems: f_v}
  end

  def self.front_view
    f_v = {}
    all.each do |waste_item|
      f_v.merge!(waste_item.front_view_with_key)
    end
    f_v
  end

  def front_view_with_name_key
    {wasteItem: front_view_with_key}
  end

  def front_view_with_key
    {id => front_view}
  end

  def front_view_with_name
    {wasteItem: front_view}
  end

  def front_view
    as_json(methods: [:waste_id, :ingredient_id, :store_item_id])
  end
end