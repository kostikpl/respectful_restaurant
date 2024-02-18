# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_02_18_230451) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "menu_items", force: :cascade do |t|
    t.integer "price_cents"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer "quantity", null: false
    t.bigint "menu_item_id", null: false
    t.bigint "reservation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_item_id"], name: "index_orders_on_menu_item_id"
    t.index ["reservation_id"], name: "index_orders_on_reservation_id"
    t.check_constraint "quantity > 0", name: "quantity_check"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "client_id"
    t.integer "table_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "table_statistics", force: :cascade do |t|
    t.integer "customer_id"
    t.integer "dishes_count"
    t.integer "total_bill_cents"
    t.integer "time_spent_seconds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "orders", "menu_items"
  add_foreign_key "orders", "reservations"
end
