require "test_helper"

class BalanceSheets::SummaryComponentTest < ViewComponent::TestCase
  include ActionView::Helpers::NumberHelper

  setup do
    @balance_sheet = balance_sheets(:one)
  end

  test "renders card wrapper" do
    render_inline(BalanceSheets::SummaryComponent.new(balance_sheet: @balance_sheet))

    assert_selector ".card"
    assert_selector ".card-body"
  end

  test "renders net_worth human attribute name label" do
    render_inline(BalanceSheets::SummaryComponent.new(balance_sheet: @balance_sheet))

    assert_text BalanceSheet.human_attribute_name(:net_worth)
  end

  test "renders formatted net_worth currency value" do
    @balance_sheet.net_worth = 12_345.67

    render_inline(BalanceSheets::SummaryComponent.new(balance_sheet: @balance_sheet))

    assert_text number_to_currency(12_345.67)
  end

  test "renders formatted total_assets and total_liabilities values" do
    @balance_sheet.total_assets = 8000.00
    @balance_sheet.total_liabilities = 2000.00

    render_inline(BalanceSheets::SummaryComponent.new(balance_sheet: @balance_sheet))

    assert_text number_to_currency(8000.00)
    assert_text number_to_currency(2000.00)
    assert_text BalanceSheet.human_attribute_name(:total_assets)
    assert_text BalanceSheet.human_attribute_name(:total_liabilities)
  end

  test "applies text-success class when net_worth is positive" do
    @balance_sheet.net_worth = 1000.00

    render_inline(BalanceSheets::SummaryComponent.new(balance_sheet: @balance_sheet))

    assert_selector "h5.text-success"
    assert_no_selector "h5.text-danger"
  end

  test "applies text-danger class when net_worth is negative" do
    @balance_sheet.net_worth = -500.00

    render_inline(BalanceSheets::SummaryComponent.new(balance_sheet: @balance_sheet))

    assert_selector "h5.text-danger"
    assert_no_selector "h5.text-success"
  end
end
