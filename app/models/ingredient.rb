class Ingredient < ApplicationRecord
  has_one :store_item, dependent: :destroy

  def self.front_view
    f_v = {}
    all.each do |ing|
      f_v.merge!(ing.front_view_with_key)
    end
    f_v
  end

  def front_view_with_key
    {id => front_view}
  end

  def front_view
    as_json(methods: [:store_item_id])
  end

  def store_item_id
    store_item.present? ? store_item.id : nil
  end
end
