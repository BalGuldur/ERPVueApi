class Client < ApplicationRecord
  before_save :set_fullname
  before_save :strip_name_surname

  acts_as_paranoid

  def initialize(args)
    super args
    self.phones = []
  end

  def self.find_all_by_phone(phone)
    where('phones::TEXT LIKE ?', "%#{phone}%")
  end

  def self.phone_present?(phone)
    find_all_by_phone(phone).present?
  end

  def phones_str(delimiter = ' ')
    (phones.inject('') { |start, phone| start + phone + delimiter }).strip
  end

  private

  def strip_name_surname
    name.strip!
    surname.strip!
  end

  def set_fullname
    self.fullname = name.strip + ' ' + surname.strip
  end
end
