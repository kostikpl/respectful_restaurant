class Reservation < ApplicationRecord
  has_many :orders

  accepts_nested_attributes_for :orders
end
