class CreateAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :account_type, null: false
      t.text :description

      t.timestamps
    end

    add_index :accounts, [ :user_id, :account_type ]
  end
end
