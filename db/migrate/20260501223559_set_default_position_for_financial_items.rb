class SetDefaultPositionForFinancialItems < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      WITH ranked_budget_items AS (
        SELECT
          id,
          ROW_NUMBER() OVER (PARTITION BY budget_id, item_type ORDER BY created_at, id) AS row_num
        FROM budget_items
      )
      UPDATE budget_items
      SET position = ranked_budget_items.row_num
      FROM ranked_budget_items
      WHERE budget_items.id = ranked_budget_items.id
        AND budget_items.position IS NULL;
    SQL

    execute <<~SQL
      WITH ranked_balance_items AS (
        SELECT
          id,
          ROW_NUMBER() OVER (PARTITION BY balance_sheet_id, type ORDER BY created_at, id) AS row_num
        FROM balance_sheet_items
      )
      UPDATE balance_sheet_items
      SET position = ranked_balance_items.row_num
      FROM ranked_balance_items
      WHERE balance_sheet_items.id = ranked_balance_items.id
        AND balance_sheet_items.position IS NULL;
    SQL

    change_column_default :budget_items, :position, from: nil, to: 0
    change_column_null :budget_items, :position, false

    change_column_default :balance_sheet_items, :position, from: nil, to: 0
    change_column_null :balance_sheet_items, :position, false
  end

  def down
    change_column_null :budget_items, :position, true
    change_column_default :budget_items, :position, from: 0, to: nil

    change_column_null :balance_sheet_items, :position, true
    change_column_default :balance_sheet_items, :position, from: 0, to: nil
  end
end
