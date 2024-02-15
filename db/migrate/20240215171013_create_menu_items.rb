class CreateMenuItems < ActiveRecord::Migration[7.1]
  def change
    create_table :menu_items do |t|
      t.integer :price_cents
      t.string :title

      t.timestamps
    end
  end
end
