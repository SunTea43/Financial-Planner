require "test_helper"

class BalanceSheets::ComparisonComponentTest < ViewComponent::TestCase
  setup do
    @balance_sheet = balance_sheets(:one)
  end

  test "renders nothing when there is no previous balance sheet" do
    # balance_sheets(:one) has no previous sheet by default
    render_inline(BalanceSheets::ComparisonComponent.new(balance_sheet: @balance_sheet))

    assert_no_selector ".card"
  end

  test "renders comparison card when a previous balance sheet exists" do
    user = @balance_sheet.user
    account = @balance_sheet.account

    user.balance_sheets.create!(
      account: account,
      recorded_at: 1.month.ago,
      total_assets: 5000.00,
      total_liabilities: 2000.00,
      net_worth: 3000.00
    )

    @balance_sheet.update!(
      recorded_at: Time.current,
      total_assets: 6000.00,
      total_liabilities: 2200.00,
      net_worth: 3800.00
    )

    render_inline(BalanceSheets::ComparisonComponent.new(balance_sheet: @balance_sheet))

    assert_selector ".card"
    assert_text "Comparativa con Balance Anterior"
  end

  test "renders assets diff section with positive indicator" do
    user = @balance_sheet.user
    account = @balance_sheet.account

    user.balance_sheets.create!(
      account: account,
      recorded_at: 1.month.ago,
      total_assets: 4000.00,
      total_liabilities: 1000.00,
      net_worth: 3000.00
    )
    @balance_sheet.update!(
      recorded_at: Time.current,
      total_assets: 5000.00,
      total_liabilities: 1000.00,
      net_worth: 4000.00
    )

    render_inline(BalanceSheets::ComparisonComponent.new(balance_sheet: @balance_sheet))

    assert_text "Variación Activos"
    assert_text "Variación Patrimonio"
    assert_text "Variación Pasivos"
  end
end
