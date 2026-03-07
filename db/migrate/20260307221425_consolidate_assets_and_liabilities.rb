class ConsolidateAssetsAndLiabilities < ActiveRecord::Migration[8.1]
  def up
    rename_table :assets, :balance_sheet_items
    rename_column :balance_sheet_items, :asset_type, :item_type
    add_column :balance_sheet_items, :type, :string

    # Update existing assets with STI type
    execute("UPDATE balance_sheet_items SET type = 'Asset'")

    # Move liabilities to balance_sheet_items
    execute(<<-SQL)
      INSERT INTO balance_sheet_items (amount, item_type, balance_sheet_id, created_at, description, name, position, updated_at, type)
      SELECT amount, liability_type, balance_sheet_id, created_at, description, name, position, updated_at, 'Liability'
      FROM liabilities
    SQL

    drop_table :liabilities
  end

  def down
    create_table "liabilities", force: :cascade do |t|
      t.decimal "amount", precision: 15, scale: 2, null: false
      t.bigint "balance_sheet_id", null: false
      t.datetime "created_at", null: false
      t.text "description"
      t.string "liability_type", null: false
      t.string "name", null: false
      t.integer "position"
      t.datetime "updated_at", null: false
      t.index [ "balance_sheet_id", "liability_type" ], name: "index_liabilities_on_balance_sheet_id_and_liability_type"
      t.index [ "balance_sheet_id" ], name: "index_liabilities_on_balance_sheet_id"
    end

    execute(<<-SQL)
      INSERT INTO liabilities (amount, liability_type, balance_sheet_id, created_at, description, name, position, updated_at)
      SELECT amount, item_type, balance_sheet_id, created_at, description, name, position, updated_at
      FROM balance_sheet_items WHERE type = 'Liability'
    SQL

    execute("DELETE FROM balance_sheet_items WHERE type = 'Liability'")
    remove_column :balance_sheet_items, :type
    rename_column :balance_sheet_items, :item_type, :asset_type
    rename_table :balance_sheet_items, :assets
  end
end
