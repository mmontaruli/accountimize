# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111124152018) do

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "country"
    t.string   "address_street_1"
    t.string   "address_street_2"
    t.string   "address_city"
    t.string   "address_state"
    t.string   "address_zip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "estimates", :force => true do |t|
    t.integer  "number"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
  end

  create_table "line_items", :force => true do |t|
    t.integer  "number"
    t.string   "name"
    t.integer  "quantity"
    t.decimal  "unit_price"
    t.boolean  "is_enabled"
    t.integer  "estimate_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
