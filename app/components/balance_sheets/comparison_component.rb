class BalanceSheets::ComparisonComponent < ApplicationComponent
  def initialize(balance_sheet:)
    @balance_sheet = balance_sheet
  end

  private

  def balance_sheet
    @balance_sheet
  end

  def comparison_data
    @comparison_data ||= balance_sheet.comparison_with_previous
  end
end
