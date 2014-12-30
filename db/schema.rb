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

ActiveRecord::Schema.define(version: 20141224191043) do

  create_table "articles", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "counterparties", force: true do |t|
    t.string   "name"
    t.date     "start_date"
    t.boolean  "active",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "value_payment"
    t.boolean  "monthly_payment"
  end

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

end
