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

ActiveRecord::Schema[8.1].define(version: 2026_05_04_193000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "account_type", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "preferred_currency", default: "COP", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index [ "preferred_currency" ], name: "index_accounts_on_preferred_currency"
    t.index [ "user_id", "account_type" ], name: "index_accounts_on_user_id_and_account_type"
    t.index [ "user_id" ], name: "index_accounts_on_user_id"
  end

  create_table "balance_sheet_items", force: :cascade do |t|
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.bigint "balance_sheet_id", null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "item_type", null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.string "type"
    t.datetime "updated_at", null: false
    t.index [ "balance_sheet_id", "item_type" ], name: "index_balance_sheet_items_on_balance_sheet_id_and_item_type"
    t.index [ "balance_sheet_id" ], name: "index_balance_sheet_items_on_balance_sheet_id"
    t.index [ "category" ], name: "index_balance_sheet_items_on_category"
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
    t.index [ "account_id" ], name: "index_balance_sheets_on_account_id"
    t.index [ "recorded_at" ], name: "index_balance_sheets_on_recorded_at"
    t.index [ "user_id", "recorded_at" ], name: "index_balance_sheets_on_user_id_and_recorded_at"
    t.index [ "user_id" ], name: "index_balance_sheets_on_user_id"
  end

  create_table "budget_items", force: :cascade do |t|
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.bigint "budget_id", null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "item_type", null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index [ "budget_id", "category" ], name: "index_budget_items_on_budget_id_and_category"
    t.index [ "budget_id", "item_type" ], name: "index_budget_items_on_budget_id_and_item_type"
    t.index [ "budget_id" ], name: "index_budget_items_on_budget_id"
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
    t.index [ "account_id" ], name: "index_budgets_on_account_id"
    t.index [ "periodicity" ], name: "index_budgets_on_periodicity"
    t.index [ "user_id", "start_date" ], name: "index_budgets_on_user_id_and_start_date"
    t.index [ "user_id" ], name: "index_budgets_on_user_id"
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.string "base_currency", null: false
    t.datetime "created_at", null: false
    t.datetime "fetched_at", null: false
    t.string "quote_currency", null: false
    t.decimal "rate", precision: 20, scale: 10, null: false
    t.string "source", default: "open_er_api", null: false
    t.datetime "updated_at", null: false
    t.index [ "base_currency", "quote_currency", "fetched_at" ], name: "index_exchange_rates_on_base_quote_fetched_at", unique: true
    t.index [ "base_currency", "quote_currency", "fetched_at" ], name: "index_exchange_rates_on_base_quote_fetched_at_desc", order: { fetched_at: :desc }
  end

  create_table "savings_plan_entries", force: :cascade do |t|
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.datetime "created_at", null: false
    t.date "entry_date", null: false
    t.string "frequency", default: "manual", null: false
    t.text "notes"
    t.bigint "savings_plan_id", null: false
    t.datetime "updated_at", null: false
    t.index [ "savings_plan_id", "entry_date" ], name: "index_savings_plan_entries_on_savings_plan_id_and_entry_date"
    t.index [ "savings_plan_id" ], name: "index_savings_plan_entries_on_savings_plan_id"
  end

  create_table "savings_plans", force: :cascade do |t|
    t.decimal "annual_interest_rate", precision: 8, scale: 4, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.decimal "goal_amount", precision: 15, scale: 2, null: false
    t.decimal "initial_capital", precision: 15, scale: 2, default: "0.0", null: false
    t.string "name", null: false
    t.date "start_date", null: false
    t.date "target_date", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index [ "user_id", "target_date" ], name: "index_savings_plans_on_user_id_and_target_date"
    t.index [ "user_id" ], name: "index_savings_plans_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index [ "email" ], name: "index_users_on_email", unique: true
    t.index [ "reset_password_token" ], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "balance_sheet_items", "balance_sheets"
  add_foreign_key "balance_sheets", "accounts"
  add_foreign_key "balance_sheets", "users"
  add_foreign_key "budget_items", "budgets"
  add_foreign_key "budgets", "accounts"
  add_foreign_key "budgets", "users"
  add_foreign_key "savings_plan_entries", "savings_plans"
  add_foreign_key "savings_plans", "users"
end
