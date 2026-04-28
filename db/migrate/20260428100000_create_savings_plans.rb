class CreateSavingsPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :savings_plans do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :goal_amount, precision: 15, scale: 2, null: false
      t.date :start_date, null: false
      t.date :target_date, null: false
      t.decimal :annual_interest_rate, precision: 8, scale: 4, null: false, default: 0

      t.timestamps
    end

    add_index :savings_plans, [:user_id, :target_date]
  end
end
