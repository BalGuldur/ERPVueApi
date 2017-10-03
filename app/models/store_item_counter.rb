class StoreItemCounter < ApplicationRecord
  include FrontViewSecond

  belongs_to :store_item
end
