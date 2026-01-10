class CreateLiabilities < ActiveRecord::Migration[8.1]
  def change
    create_table :liabilities do |t|
      t.references :balance_sheet, null: false, foreign_key: true
      t.string :name, null: false
      t.string :liability_type, null: false
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.text :description

      t.timestamps
    end

    add_index :liabilities, [ :balance_sheet_id, :liability_type ]
  end
end
