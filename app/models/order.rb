class Order < ApplicationRecord
  belongs_to :menu_item
  belongs_to :reservation
end
