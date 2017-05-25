class WorkDay < ApplicationRecord
  has_many :shifts

  def self.close
    @work_day = WorkDay.where(closeOn: nil).last
    if (@work_day.present? and !@work_day.shift_is_open)
      @work_day.close
    end
    @work_day
  end

  def self.active
    @work_day = WorkDay.where(closeOn: nil).last
    @work_day
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

  # Стандартный набор для генерации front_view
  def self.front_view_with_name_key
    f_v = {}
    all.each do |work_day|
      f_v.merge!(work_day.front_view_with_key)
    end
    {workDays: f_v}
  end

  def self.front_view
    f_v = {}
    all.each do |work_day|
      f_v.merge!(work_day.front_view_with_key)
    end
    f_v
  end

  def front_view_with_name_key
    {workDays: front_view_with_key}
  end

  def front_view_with_key
    {id => front_view}
  end

  def front_view
    as_json(methods: [:shift_ids])
  end
end
