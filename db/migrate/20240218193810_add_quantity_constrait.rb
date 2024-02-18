class AddQuantityConstrait < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :orders, "quantity > 0", name: "quantity_check"
  end
end
