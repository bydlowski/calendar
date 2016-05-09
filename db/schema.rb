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

ActiveRecord::Schema.define(version: 20160509175109) do

  create_table "holiday1s", force: :cascade do |t|
    t.string   "holiday_city"
    t.string   "holiday_city_full"
    t.string   "holiday_name"
    t.integer  "holiday_date"
    t.integer  "holiday_date_ly"
    t.boolean  "national"
    t.boolean  "municipal"
    t.boolean  "servidor"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "tests", force: :cascade do |t|
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
