class BalanceSheets::SummaryComponent < ApplicationComponent
  def initialize(balance_sheet:)
    @balance_sheet = balance_sheet
  end

  private

  def balance_sheet
    @balance_sheet
  end
end
