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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150626080426) do

  create_table "articles", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_infos", force: true do |t|
    t.integer  "customer_id"
    t.string   "name"
    t.string   "agreement"
    t.integer  "invoice_id"
    t.string   "address"
    t.string   "repr_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title_en"
    t.string   "title_ua"
  end

  add_index "client_infos", ["customer_id"], name: "index_client_infos_on_customer_id", using: :btree
  add_index "client_infos", ["invoice_id"], name: "index_client_infos_on_invoice_id", using: :btree

  create_table "counterparties", force: true do |t|
    t.string   "name"
    t.date     "start_date"
    t.boolean  "active",                   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "value_payment"
    t.boolean  "monthly_payment"
    t.string   "type"
    t.integer  "customer_id"
    t.string   "email"
    t.string   "password"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean  "approve_hours",            default: false
    t.boolean  "signed_in",                default: false
    t.string   "currency_monthly_payment", default: "USD"
  end

  create_table "holidays", force: true do |t|
    t.string   "name"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hours", force: true do |t|
    t.integer  "vendor_id"
    t.integer  "customer_id"
    t.integer  "hours"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "month"
  end

  add_index "hours", ["customer_id"], name: "index_hours_on_customer_id", using: :btree
  add_index "hours", ["vendor_id"], name: "index_hours_on_vendor_id", using: :btree

  create_table "registers", force: true do |t|
    t.date     "date"
    t.integer  "article_id"
    t.integer  "counterparty_id"
    t.float    "value"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "background"
    t.string   "type"
    t.string   "currency",        default: "UAH"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vendor_acts", force: true do |t|
    t.string   "total_money"
    t.date     "month"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vendor_acts", ["vendor_id"], name: "index_vendor_acts_on_vendor_id", using: :btree

  create_table "vendor_infos", force: true do |t|
    t.string   "name"
    t.string   "ipn"
    t.string   "address"
    t.string   "contract"
    t.string   "account"
    t.string   "bank"
    t.integer  "mfo"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vendor_infos", ["vendor_id"], name: "index_vendor_infos_on_vendor_id", using: :btree

end
