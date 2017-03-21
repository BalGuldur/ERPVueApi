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

ActiveRecord::Schema.define(version: 20170320224740) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cash_boxes", force: :cascade do |t|
    t.string   "title"
    t.integer  "discount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "check_items", force: :cascade do |t|
    t.integer  "discount"
    t.string   "tech_card_title"
    t.float    "tech_card_price"
    t.integer  "qty"
    t.float    "amount_paid"
    t.integer  "tech_card_id"
    t.integer  "check_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["check_id"], name: "index_check_items_on_check_id", using: :btree
    t.index ["tech_card_id"], name: "index_check_items_on_tech_card_id", using: :btree
  end

  create_table "checks", force: :cascade do |t|
    t.string   "client"
    t.float    "summ"
    t.string   "cash_box_title"
    t.integer  "cash_box_discount"
    t.integer  "cash_box_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["cash_box_id"], name: "index_checks_on_cash_box_id", using: :btree
  end

  create_table "ingredients", force: :cascade do |t|
    t.string   "title"
    t.string   "measure"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingredients_store_menu_categories", id: false, force: :cascade do |t|
    t.integer "store_menu_category_id", null: false
    t.integer "ingredient_id",          null: false
    t.index ["ingredient_id", "store_menu_category_id"], name: "ing_to_st_mn_cat", using: :btree
    t.index ["store_menu_category_id", "ingredient_id"], name: "st_mn_cat_to_ing", using: :btree
  end

  create_table "store_items", force: :cascade do |t|
    t.float    "price"
    t.float    "remains"
    t.integer  "ingredient_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["ingredient_id"], name: "index_store_items_on_ingredient_id", using: :btree
  end

  create_table "store_menu_categories", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "store_menu_categories_tech_cards", id: false, force: :cascade do |t|
    t.integer "store_menu_category_id", null: false
    t.integer "tech_card_id",           null: false
    t.index ["store_menu_category_id", "tech_card_id"], name: "st_mn_cat_tch_card", using: :btree
    t.index ["tech_card_id", "store_menu_category_id"], name: "tch_card_st_mn_cat", using: :btree
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

  add_foreign_key "check_items", "checks"
  add_foreign_key "check_items", "tech_cards"
  add_foreign_key "checks", "cash_boxes"
  add_foreign_key "store_items", "ingredients"
  add_foreign_key "tech_card_items", "ingredients"
  add_foreign_key "tech_card_items", "tech_cards"
end
