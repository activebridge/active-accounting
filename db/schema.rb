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

ActiveRecord::Schema.define(version: 20160909080732) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 191, default: "", null: false
    t.string   "encrypted_password",     limit: 191, default: "", null: false
    t.string   "reset_password_token",   limit: 191
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "articles", force: :cascade do |t|
    t.string   "name",       limit: 191
    t.string   "type",       limit: 191
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_acts", force: :cascade do |t|
    t.string   "total_money",  limit: 191
    t.date     "month"
    t.integer  "customer_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "signature_id", limit: 4
  end

  add_index "client_acts", ["customer_id"], name: "index_client_acts_on_customer_id", using: :btree
  add_index "client_acts", ["signature_id"], name: "index_client_acts_on_signature_id", using: :btree

  create_table "client_infos", force: :cascade do |t|
    t.integer  "customer_id",      limit: 4
    t.string   "name",             limit: 191
    t.string   "agreement_number", limit: 191
    t.integer  "invoice_id",       limit: 4
    t.string   "address",          limit: 191
    t.string   "repr_name",        limit: 191
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title_en",         limit: 191
    t.string   "title_ua",         limit: 191
    t.date     "agreement_date"
  end

  add_index "client_infos", ["customer_id"], name: "index_client_infos_on_customer_id", using: :btree
  add_index "client_infos", ["invoice_id"], name: "index_client_infos_on_invoice_id", using: :btree

  create_table "client_invoices", force: :cascade do |t|
    t.date     "month"
    t.integer  "customer_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "signature_id", limit: 4
  end

  add_index "client_invoices", ["customer_id"], name: "index_client_invoices_on_customer_id", using: :btree
  add_index "client_invoices", ["signature_id"], name: "index_client_invoices_on_signature_id", using: :btree

  create_table "counterparties", force: :cascade do |t|
    t.string   "name",                     limit: 191
    t.date     "start_date"
    t.boolean  "active",                               default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "value_payment",            limit: 24
    t.boolean  "monthly_payment"
    t.string   "type",                     limit: 191
    t.integer  "customer_id",              limit: 4
    t.string   "email",                    limit: 191
    t.string   "password",                 limit: 191
    t.string   "auth_token",               limit: 191
    t.string   "password_reset_token",     limit: 191
    t.datetime "password_reset_sent_at"
    t.boolean  "approve_hours",                        default: false
    t.boolean  "signed_in",                            default: false
    t.string   "currency_monthly_payment", limit: 191, default: "USD"
  end

  create_table "features", force: :cascade do |t|
    t.string   "name",       limit: 191
    t.string   "type",       limit: 191
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "features_vendor_orders", id: false, force: :cascade do |t|
    t.integer  "vendor_order_id", limit: 4, null: false
    t.integer  "feature_id",      limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "holidays", force: :cascade do |t|
    t.string   "name",       limit: 191
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hours", force: :cascade do |t|
    t.integer  "vendor_id",   limit: 4
    t.integer  "customer_id", limit: 4
    t.integer  "hours",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "month"
  end

  add_index "hours", ["customer_id"], name: "index_hours_on_customer_id", using: :btree
  add_index "hours", ["vendor_id"], name: "index_hours_on_vendor_id", using: :btree

  create_table "payment_histories", force: :cascade do |t|
    t.integer  "counterparty_id", limit: 4
    t.integer  "admin_id",        limit: 4
    t.float    "value_payment",   limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_histories", ["counterparty_id"], name: "index_payment_histories_on_counterparty_id", using: :btree

  create_table "registers", force: :cascade do |t|
    t.date     "date"
    t.integer  "article_id",      limit: 4
    t.integer  "counterparty_id", limit: 4
    t.float    "value",           limit: 24
    t.text     "notes",           limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "background",      limit: 191
    t.string   "type",            limit: 191
    t.string   "currency",        limit: 191,   default: "UAH"
    t.integer  "vendor_id",       limit: 4
  end

  create_table "signatures", force: :cascade do |t|
    t.string   "name_ua",    limit: 191
    t.string   "name_en",    limit: 191
    t.string   "title_en",   limit: 191
    t.string   "title_ua",   limit: 191
    t.string   "tel",        limit: 191
    t.string   "email",      limit: 191
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taxes", force: :cascade do |t|
    t.float    "social",     limit: 24
    t.float    "single",     limit: 24
    t.float    "cash",       limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vacations", force: :cascade do |t|
    t.integer "vendor_id", limit: 4
    t.date    "start"
    t.date    "ending"
  end

  add_index "vacations", ["vendor_id"], name: "index_vacations_on_vendor_id", using: :btree

  create_table "vendor_acts", force: :cascade do |t|
    t.string   "total_money",  limit: 191
    t.date     "month"
    t.integer  "vendor_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "signature_id", limit: 4
  end

  add_index "vendor_acts", ["signature_id"], name: "index_vendor_acts_on_signature_id", using: :btree
  add_index "vendor_acts", ["vendor_id"], name: "index_vendor_acts_on_vendor_id", using: :btree

  create_table "vendor_infos", force: :cascade do |t|
    t.string   "name",           limit: 191
    t.string   "ipn",            limit: 191
    t.string   "address",        limit: 191
    t.string   "contract",       limit: 191
    t.string   "account",        limit: 191
    t.string   "bank",           limit: 191
    t.integer  "mfo",            limit: 4
    t.integer  "vendor_id",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "agreement_date"
  end

  add_index "vendor_infos", ["vendor_id"], name: "index_vendor_infos_on_vendor_id", using: :btree

  create_table "vendor_orders", force: :cascade do |t|
    t.date     "month"
    t.integer  "vendor_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "signature_id", limit: 4
  end

  add_index "vendor_orders", ["signature_id"], name: "index_vendor_orders_on_signature_id", using: :btree
  add_index "vendor_orders", ["vendor_id"], name: "index_vendor_orders_on_vendor_id", using: :btree

end
