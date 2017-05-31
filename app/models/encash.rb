class Encash < ApplicationRecord
  has_many :encash_logs

  def encashing cashBox, amount
    Encash.transaction do
      amount = amount.to_f
      oldCash = cash || 0
      encashPaid = (amount / 100) * cashBox.encashPercent
      newCash = oldCash + amount
      encashLog = EncashLog.new(
        cash_box: cashBox,
        oldCash: oldCash,
        newCash: newCash,
        encashPaid: encashPaid,
        encashPercent: cashBox.encashPercent
      )
      self.cash = newCash
      cashBoxCash = (cashBox.cash || 0) - amount - encashPaid
      cashBox.change_cash cashBoxCash
      cashBox.save!
      encashLog.save!
      save!
    end
  end
end
