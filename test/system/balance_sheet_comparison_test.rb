require "application_system_test_case"

class BalanceSheetComparisonTest < ApplicationSystemTestCase
  setup do
    @user = User.create!(email: "system_test_#{Time.now.to_i}@example.com", password: "password123")
    login_as @user
    @account = @user.accounts.create!(name: "System Test Account", account_type: "checking")

    # Create previous balance sheet
    @prev_bs = BalanceSheet.create!(
      user: @user,
      account: @account,
      recorded_at: 1.month.ago,
      assets_attributes: [ { name: "Savings", amount: 1000, asset_type: "liquid" } ]
    )

    # Create current balance sheet
    @current_bs = BalanceSheet.create!(
      user: @user,
      account: @account,
      recorded_at: Time.current,
      assets_attributes: [ { name: "Savings", amount: 1500, asset_type: "liquid" } ]
    )
  end

  test "visiting the show page displays comparison with previous balance sheet" do
    visit balance_sheet_path(@current_bs)

    assert_selector "h5", text: "Comparativa con Balance Anterior"
    assert_selector "h4", text: "+$500.00" # Variación Activos
    assert_selector "td", text: "Savings"
    assert_selector "td.text-success", text: "+$500.00"

    # Also check the report page
    visit report_balance_sheet_path(@current_bs)
    assert_selector "h5", text: "Comparativa con Balance Anterior"
    assert_selector "h4", text: "+$500.00"
  end
end
