class CreateSavingsPlanEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :savings_plan_entries do |t|
      t.references :savings_plan, null: false, foreign_key: true
      t.date :entry_date, null: false
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.string :frequency, null: false, default: "manual"
      t.text :notes

      t.timestamps
    end

    add_index :savings_plan_entries, [ :savings_plan_id, :entry_date ]
  end
end
