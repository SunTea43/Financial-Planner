class AddUseConversionFactorsToAccounts < ActiveRecord::Migration[8.1]
  def change
    add_column :accounts, :use_conversion_factors, :boolean, default: true, null: false
  end
end
