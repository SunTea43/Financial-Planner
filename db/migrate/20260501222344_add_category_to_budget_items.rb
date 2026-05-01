class AddCategoryToBudgetItems < ActiveRecord::Migration[8.1]
  def change
    add_column :budget_items, :category, :string
    add_index :budget_items, [ :budget_id, :category ]
  end
end
