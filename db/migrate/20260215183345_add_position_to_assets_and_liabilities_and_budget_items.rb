class AddPositionToAssetsAndLiabilitiesAndBudgetItems < ActiveRecord::Migration[8.1]
  def change
    add_column :assets, :position, :integer
    add_column :liabilities, :position, :integer
    add_column :budget_items, :position, :integer
  end
end
