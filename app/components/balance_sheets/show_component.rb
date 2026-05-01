class BalanceSheets::ShowComponent < ApplicationComponent
  def initialize(balance_sheet:)
    @balance_sheet = balance_sheet
  end

  private

  def balance_sheet
    @balance_sheet
  end

  def liquid_assets
    balance_sheet.assets.select(&:liquid?)
  end

  def fixed_assets
    balance_sheet.assets.select(&:fixed?)
  end

  def short_term_liabilities
    balance_sheet.liabilities.select(&:short_term?)
  end

  def long_term_liabilities
    balance_sheet.liabilities.select(&:long_term?)
  end
end
