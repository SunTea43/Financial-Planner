class CreateBudgetItems < ActiveRecord::Migration[8.1]
  def change
    create_table :budget_items do |t|
      t.references :budget, null: false, foreign_key: true
      t.string :name, null: false
      t.string :item_type, null: false
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.text :description

      t.timestamps
    end

    add_index :budget_items, [ :budget_id, :item_type ]
  end
end
