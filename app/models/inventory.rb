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

  # Отложить инвентаризацию
  def later(inventory_params, inven_items_params)
    transaction do
      if id.nil?
        create_new(inventory_params, inven_items_params)
      else
        update_old(inventory_params, inven_items_params)
      end
      self.status = 'later'
      save!
    end
  end

  def done(inventory_params, inven_items_params)
    transaction do
      if id.nil?
        create_new(inventory_params, inven_items_params)
      else
        update_old(inventory_params, inven_items_params)
      end
      fix_store
      self.status = 'done'
      save!
    end
  end

  def update_old(inventory_params, inven_items_params)
    transaction do
      self.doDate = inventory_params[:doDate]
      inven_items_params.each do |key, inven_item|
        finded_inven_item = inventory_items.find_by(store_item_id: inven_item[:store_item_id])
        if finded_inven_item.present?
          inventory_items.find(finded_inven_item.id).update inven_item
        else
          inventory_items << InventoryItem.new(inven_item)
        end
      end
      save!
    end
  end

  def create_new(inventory_params, inven_items_params)
    transaction do
      self.doDate = inventory_params[:doDate]
      inven_items_params.each do |key, inven_item|
        # puts("item params key #{key}, inventItem #{inven_item.as_json}")
        inventory_items << InventoryItem.new(inven_item)
      end
      save!
    end
  end

  private

  def fix_store
    inventory_items.find_each {|item| item.store_merge}
  end

  def calculate_diff
    diffQty = 0
    diffSumm = 0
    inventory_items.find_each do |inv_item|
      diffQty = diffQty + 1 if !inv_item.diffQty.nil? && inv_item.diffQty != 0
      diffSumm = diffSumm + inv_item.diffSumm if !inv_item.diffSumm.nil? && inv_item.diffQty != 0
    end
    self.update_column(:diffQty, diffQty)
    self.update_column(:diffSumm, diffSumm)
  end
end
