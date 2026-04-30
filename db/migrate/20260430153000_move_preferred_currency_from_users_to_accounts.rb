class MovePreferredCurrencyFromUsersToAccounts < ActiveRecord::Migration[8.1]
  def up
    add_column :accounts, :preferred_currency, :string, default: "COP", null: false
    add_index :accounts, :preferred_currency

    execute <<~SQL
      UPDATE accounts
      SET preferred_currency = COALESCE(NULLIF(users.preferred_currency, ''), 'COP')
      FROM users
      WHERE accounts.user_id = users.id
    SQL

    remove_column :users, :preferred_currency, :string
  end

  def down
    add_column :users, :preferred_currency, :string, default: "COP", null: false

    execute <<~SQL
      UPDATE users
      SET preferred_currency = COALESCE(NULLIF(account_currencies.preferred_currency, ''), 'COP')
      FROM (
        SELECT DISTINCT ON (user_id) user_id, preferred_currency
        FROM accounts
        ORDER BY user_id, created_at ASC
      ) AS account_currencies
      WHERE users.id = account_currencies.user_id
    SQL

    remove_index :accounts, :preferred_currency
    remove_column :accounts, :preferred_currency, :string
  end
end
