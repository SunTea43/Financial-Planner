class AddInitialCapitalToSavingsPlans < ActiveRecord::Migration[8.1]
  def change
    add_column :savings_plans, :initial_capital, :decimal, precision: 15, scale: 2, null: false, default: 0
  end
end
