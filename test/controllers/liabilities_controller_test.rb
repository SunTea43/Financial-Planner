require "test_helper"

class LiabilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
    @account = accounts(:one)
  end

  test "liability history chart data is sorted chronologically by recorded_at" do
    # Create balance sheets out of order (chronologically) but same creation order
    # BS1: February (recorded first, chronologically later)
    bs_feb = BalanceSheet.create!(
      user: @user,
      account: @account,
      recorded_at: "2026-02-15",
      total_assets: 100,
      total_liabilities: 100,
      net_worth: 0
    )
    liability_feb = bs_feb.liabilities.create!(
      name: "Loan Chart Test",
      amount: 1000,
      liability_type: "short_term",
      position: 1
    )

    # BS2: January (recorded second, chronologically earlier)
    bs_jan = BalanceSheet.create!(
      user: @user,
      account: @account,
      recorded_at: "2026-01-10",
      total_assets: 100,
      total_liabilities: 90,
      net_worth: 10
    )
    bs_jan.liabilities.create!(
      name: "Loan Chart Test",
      amount: 900,
      liability_type: "short_term",
      position: 2
    )

    get financial_liability_path(liability_feb)
    assert_response :success

    # Check the labels in the chart data within the HTML
    assert_match(/2026-01-10.*2026-02-15/, response.body)
    assert_match(/900\.0.*1000\.0/, response.body)
  end
end
