class CreateAssets < ActiveRecord::Migration[8.1]
  def change
    create_table :assets do |t|
      t.references :balance_sheet, null: false, foreign_key: true
      t.string :name, null: false
      t.string :asset_type, null: false
      t.string :category
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.text :description

      t.timestamps
    end

    add_index :assets, [ :balance_sheet_id, :asset_type ]
    add_index :assets, :category
  end
end
