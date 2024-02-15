class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.integer :client_id
      t.integer :table_id
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
