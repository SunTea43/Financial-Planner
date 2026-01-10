class CreateBudgets < ActiveRecord::Migration[8.1]
  def change
    create_table :budgets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :account, null: true, foreign_key: true
      t.string :name, null: false
      t.string :periodicity, null: false, default: 'monthly'
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.decimal :total_income, precision: 15, scale: 2, default: 0.0
      t.decimal :total_expenses, precision: 15, scale: 2, default: 0.0
      t.decimal :free_cash_flow, precision: 15, scale: 2, default: 0.0

      t.timestamps
    end

    add_index :budgets, [ :user_id, :start_date ]
    add_index :budgets, :periodicity
  end
end
