class WorkDay < ApplicationRecord
  has_many :shifts

  def self.close
    @work_day = WorkDay.where(closeOn: nil).last
    if (@work_day.present? and !@work_day.shift_is_open)
      @work_day.close
      return @work_day
    else
      return @work_day
    end
  end

  def shift_is_open
    self.shifts.find_by(closeOn: nil).present?
  end

  def close
    transaction do
      self.closeOn = DateTime.now
      save!
    end
  end
end
