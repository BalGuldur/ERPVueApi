class CashBoxAnalitic < ApplicationRecord
  belongs_to :shift
  belongs_to :cash_box

  serialize :cashBoxSave
end
