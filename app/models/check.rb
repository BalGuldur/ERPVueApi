class Check < ApplicationRecord
  has_many :check_items, dependent: :destroy
  belongs_to :cash_box

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
    as_json(methods: [:check_item_ids, :cash_box_id])
  end
end