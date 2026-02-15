# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_15_183345) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "account_type", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "account_type"], name: "index_accounts_on_user_id_and_account_type"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "assets", force: :cascade do |t|
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.string "asset_type", null: false
    t.bigint "balance_sheet_id", null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["balance_sheet_id", "asset_type"], name: "index_assets_on_balance_sheet_id_and_asset_type"
    t.index ["balance_sheet_id"], name: "index_assets_on_balance_sheet_id"
    t.index ["category"], name: "index_assets_on_category"
  end

  create_table "balance_sheets", force: :cascade do |t|
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.decimal "net_worth", precision: 15, scale: 2, default: "0.0"
    t.text "notes"
    t.datetime "recorded_at", null: false
    t.decimal "total_assets", precision: 15, scale: 2, default: "0.0"
    t.decimal "total_liabilities", precision: 15, scale: 2, default: "0.0"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["account_id"], name: "index_balance_sheets_on_account_id"
    t.index ["recorded_at"], name: "index_balance_sheets_on_recorded_at"
    t.index ["user_id", "recorded_at"], name: "index_balance_sheets_on_user_id_and_recorded_at"
    t.index ["user_id"], name: "index_balance_sheets_on_user_id"
  end

  create_table "budget_items", force: :cascade do |t|
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.bigint "budget_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "item_type", null: false
    t.string "name", null: false
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["budget_id", "item_type"], name: "index_budget_items_on_budget_id_and_item_type"
    t.index ["budget_id"], name: "index_budget_items_on_budget_id"
  end

  create_table "budgets", force: :cascade do |t|
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.date "end_date", null: false
    t.decimal "free_cash_flow", precision: 15, scale: 2, default: "0.0"
    t.string "name", null: false
    t.string "periodicity", default: "monthly", null: false
    t.date "start_date", null: false
    t.decimal "total_expenses", precision: 15, scale: 2, default: "0.0"
    t.decimal "total_income", precision: 15, scale: 2, default: "0.0"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["account_id"], name: "index_budgets_on_account_id"
    t.index ["periodicity"], name: "index_budgets_on_periodicity"
    t.index ["user_id", "start_date"], name: "index_budgets_on_user_id_and_start_date"
    t.index ["user_id"], name: "index_budgets_on_user_id"
  end

  create_table "liabilities", force: :cascade do |t|
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.bigint "balance_sheet_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "liability_type", null: false
    t.string "name", null: false
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["balance_sheet_id", "liability_type"], name: "index_liabilities_on_balance_sheet_id_and_liability_type"
    t.index ["balance_sheet_id"], name: "index_liabilities_on_balance_sheet_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "assets", "balance_sheets"
  add_foreign_key "balance_sheets", "accounts"
  add_foreign_key "balance_sheets", "users"
  add_foreign_key "budget_items", "budgets"
  add_foreign_key "budgets", "accounts"
  add_foreign_key "budgets", "users"
  add_foreign_key "liabilities", "balance_sheets"
end
