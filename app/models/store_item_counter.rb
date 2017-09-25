class StoreItemCounter < ApplicationRecord
  include FrontView

  belongs_to :store_item
end
