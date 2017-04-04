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

ActiveRecord::Schema.define(version: 20170403141243) do

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
    t.datetime "paidOn"
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

  create_table "inventories", force: :cascade do |t|
    t.datetime "doDate"
    t.integer  "diffQty"
    t.float    "diffSumm"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventory_items", force: :cascade do |t|
    t.integer  "inventory_id"
    t.integer  "ingredient_id"
    t.float    "qty"
    t.text     "comment"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "store_item_id"
    t.float    "diffQty"
    t.float    "storeQty"
    t.index ["ingredient_id"], name: "index_inventory_items_on_ingredient_id", using: :btree
    t.index ["inventory_id"], name: "index_inventory_items_on_inventory_id", using: :btree
  end

  create_table "store_item_counters", force: :cascade do |t|
    t.integer  "store_item_id"
    t.float    "storeNewQty"
    t.float    "storeOldQty"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["store_item_id"], name: "index_store_item_counters_on_store_item_id", using: :btree
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

  create_table "supplies", force: :cascade do |t|
    t.datetime "supplyDate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "supply_items", force: :cascade do |t|
    t.integer  "supply_id"
    t.float    "qty"
    t.float    "summ"
    t.float    "price"
    t.string   "ingTitle"
    t.integer  "ingredient_id"
    t.integer  "store_item_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["ingredient_id"], name: "index_supply_items_on_ingredient_id", using: :btree
    t.index ["store_item_id"], name: "index_supply_items_on_store_item_id", using: :btree
    t.index ["supply_id"], name: "index_supply_items_on_supply_id", using: :btree
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

  create_table "waste_items", force: :cascade do |t|
    t.integer  "waste_id"
    t.integer  "ingredient_id"
    t.integer  "store_item_id"
    t.float    "storeItemPrice"
    t.string   "ingMeasure"
    t.float    "qty"
    t.float    "price"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["ingredient_id"], name: "index_waste_items_on_ingredient_id", using: :btree
    t.index ["store_item_id"], name: "index_waste_items_on_store_item_id", using: :btree
    t.index ["waste_id"], name: "index_waste_items_on_waste_id", using: :btree
  end

  create_table "wastes", force: :cascade do |t|
    t.float    "summ"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "check_items", "checks"
  add_foreign_key "check_items", "tech_cards"
  add_foreign_key "checks", "cash_boxes"
  add_foreign_key "inventory_items", "ingredients"
  add_foreign_key "inventory_items", "inventories"
  add_foreign_key "store_item_counters", "store_items"
  add_foreign_key "store_items", "ingredients"
  add_foreign_key "supply_items", "supplies"
  add_foreign_key "tech_card_items", "ingredients"
  add_foreign_key "tech_card_items", "tech_cards"
  add_foreign_key "waste_items", "ingredients"
  add_foreign_key "waste_items", "store_items"
  add_foreign_key "waste_items", "wastes"
end
