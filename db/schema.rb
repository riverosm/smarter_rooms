# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_11_132549) do

  create_table "accesories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "icon"
    t.index ["name"], name: "index_accesories_on_name", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.datetime "valid_from"
    t.datetime "valid_to"
    t.integer "number_of_attendants"
    t.integer "user_id"
    t.integer "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_bookings_on_room_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "buildings", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "room_accesories", force: :cascade do |t|
    t.integer "quantity"
    t.integer "room_id"
    t.integer "accesory_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["accesory_id"], name: "index_room_accesories_on_accesory_id"
    t.index ["room_id"], name: "index_room_accesories_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.integer "floor"
    t.integer "max_capacity"
    t.boolean "active"
    t.integer "building_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_rooms_on_building_id"
    t.index ["code"], name: "index_rooms_on_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "password_digest"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
