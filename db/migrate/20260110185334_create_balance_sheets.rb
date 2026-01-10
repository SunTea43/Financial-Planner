class CreateBalanceSheets < ActiveRecord::Migration[8.1]
  def change
    create_table :balance_sheets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :account, null: true, foreign_key: true
      t.datetime :recorded_at, null: false
      t.decimal :total_assets, precision: 15, scale: 2, default: 0.0
      t.decimal :total_liabilities, precision: 15, scale: 2, default: 0.0
      t.decimal :net_worth, precision: 15, scale: 2, default: 0.0
      t.text :notes

      t.timestamps
    end

    add_index :balance_sheets, :recorded_at
    add_index :balance_sheets, [ :user_id, :recorded_at ]
  end
end
