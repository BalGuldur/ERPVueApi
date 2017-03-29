class Inventory < ApplicationRecord
  has_many :inventory_items, dependent: :destroy

  def self.front_view
    f_v = {}
    all.order(:doDate).each do |ing|
      f_v.merge!(ing.front_view_with_key)
    end
    f_v
  end

  def front_view_with_key
    {id => front_view}
  end

  def front_view_with_name
    {inventory: front_view}
  end

  def front_view
    as_json(methods: [:inventory_item_ids])
  end

  def done
    inventory_items.each do |invent_item|
      unless invent_item.store_merge
        errors << {inventory_item: 'error on store_merge'}
      end
    end
    if errors.empty?
      self.status = 'done'
      save
    end
    errors.empty?
  end
end
