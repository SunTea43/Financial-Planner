class BalanceSheets::ShowComponent < ApplicationComponent
  def initialize(balance_sheet:)
    @balance_sheet = balance_sheet
  end

  private

  def balance_sheet
    @balance_sheet
  end

  def liquid_assets
    balance_sheet.assets.select { |a| a.item_type == "liquid" }
  end

  def fixed_assets
    balance_sheet.assets.select { |a| a.item_type == "fixed" }
  end
end
