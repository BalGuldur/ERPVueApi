class Inventory < ApplicationRecord
  include FrontViewSecond
  has_many :inventory_items, dependent: :destroy
  after_save :calculate_diff

  # Определение связей для генерации front veiw
  # { model: '', type: 'many/one', rev_type: 'many/one', index_inc: true/false }
  def self.refs
    [
        { model: 'inventory_items', type: 'many', rev_type: 'one', index_inc: true }
    ]
  end

  # def self.front_view
  #   f_v = {}
  #   all.order(:doDate).each do |ing|
  #     f_v.merge!(ing.front_view_with_key)
  #   end
  #   f_v
  # end
  #
  # def front_view_with_key
  #   {id => front_view}
  # end
  #
  # def front_view_with_name
  #   {inventory: front_view}
  # end
  #
  # def front_view
  #   as_json(methods: [:inventory_item_ids])
  # end

  def done
    # TODO: Завернуть вызов в транзакцию
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

  private

  def calculate_diff
    self.diffQty = 0
    self.diffSumm = 0
    inventory_items.each do |inv_item|
      self.diffQty = diffQty + 1 if inv_item.diffQty != 0
      self.diffSumm = diffSumm + inv_item.diffSumm
    end
  end
end
