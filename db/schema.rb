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

ActiveRecord::Schema.define(:version => 20120621195609) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "account_id"
    t.boolean  "is_account_master"
  end

  create_table "estimates", :force => true do |t|
    t.integer  "number"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
    t.boolean  "is_accepted"
  end

  create_table "invoice_milestones", :force => true do |t|
    t.integer  "order"
    t.text     "description"
    t.integer  "estimate_percentage"
    t.integer  "invoice_schedule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_schedules", :force => true do |t|
    t.integer  "estimate_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", :force => true do |t|
    t.integer  "number"
    t.date     "date"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "hours_qty"
    t.decimal  "hours_rate"
    t.integer  "fixed_qty"
    t.decimal  "fixed_rate"
    t.string   "price_type"
    t.boolean  "is_accepted", :default => false
    t.boolean  "is_locked"
  end

  create_table "negotiate_lines", :force => true do |t|
    t.text     "description"
    t.integer  "line_item_id"
    t.integer  "line_qty"
    t.decimal  "line_price"
    t.decimal  "hours_rate"
    t.integer  "hours_qty"
    t.decimal  "fixed_rate"
    t.integer  "fixed_qty"
    t.string   "price_type"
    t.string   "user_negotiating"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_accepted"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
  end

end
