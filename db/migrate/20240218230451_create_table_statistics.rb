class CreateTableStatistics < ActiveRecord::Migration[7.1]
  def change
    create_table :table_statistics do |t|
      t.integer :customer_id
      t.integer :dishes_count
      t.integer :total_bill_cents
      t.integer :time_spent_seconds
    end
  end
end
