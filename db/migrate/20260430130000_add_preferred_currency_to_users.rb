class AddPreferredCurrencyToUsers < ActiveRecord::Migration[8.1]
  def up
    add_column :users, :preferred_currency, :string, default: "COP", null: false

    execute <<~SQL
      UPDATE users
      SET preferred_currency = 'COP'
      WHERE preferred_currency IS NULL OR preferred_currency = ''
    SQL
  end

  def down
    remove_column :users, :preferred_currency
  end
end
