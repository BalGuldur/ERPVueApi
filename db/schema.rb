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

ActiveRecord::Schema.define(version: 20170315085724) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ingredients", force: :cascade do |t|
    t.string   "title"
    t.string   "measure"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "store_items", force: :cascade do |t|
    t.float    "price"
    t.float    "remains"
    t.integer  "ingredient_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["ingredient_id"], name: "index_store_items_on_ingredient_id", using: :btree
  end

  create_table "tech_card_items", force: :cascade do |t|
    t.float    "qty"
    t.integer  "ingredient_id"
    t.integer  "tech_card_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["ingredient_id"], name: "index_tech_card_items_on_ingredient_id", using: :btree
    t.index ["tech_card_id"], name: "index_tech_card_items_on_tech_card_id", using: :btree
  end

  create_table "tech_cards", force: :cascade do |t|
    t.string   "title"
    t.float    "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "store_items", "ingredients"
  add_foreign_key "tech_card_items", "ingredients"
  add_foreign_key "tech_card_items", "tech_cards"
end
