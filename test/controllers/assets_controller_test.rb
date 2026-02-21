require "test_helper"

class AssetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
    @account = accounts(:one)
  end

  test "asset history chart data is sorted chronologically by recorded_at" do
    # Create balance sheets out of order (chronologically) but same creation order
    # BS1: February (recorded first, chronologically later)
    bs_feb = BalanceSheet.create!(
      user: @user,
      account: @account,
      recorded_at: "2026-02-15",
      total_assets: 100,
      total_liabilities: 0,
      net_worth: 100
    )
    asset_feb = bs_feb.assets.create!(
      name: "Savings Chart Test",
      amount: 1000,
      asset_type: "liquid",
      position: 1
    )

    # BS2: January (recorded second, chronologically earlier)
    bs_jan = BalanceSheet.create!(
      user: @user,
      account: @account,
      recorded_at: "2026-01-10",
      total_assets: 100,
      total_liabilities: 0,
      net_worth: 100
    )
    bs_jan.assets.create!(
      name: "Savings Chart Test",
      amount: 900,
      asset_type: "liquid",
      position: 2 # Different position to test if default_scope interferes
    )

    get financial_asset_path(asset_feb)
    assert_response :success

    # Check the labels in the chart data within the HTML
    assert_match(/2026-01-10.*2026-02-15/, response.body)
    assert_match(/900\.0.*1000\.0/, response.body)
  end
end
