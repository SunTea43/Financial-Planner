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
      item_type: "liquid",
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
      item_type: "liquid",
      position: 2 # Different position to test if default_scope interferes
    )

    get financial_asset_path(asset_feb)
    assert_response :success

    # Check the labels in the chart data within the HTML
    assert_match(/2026-01-10.*2026-02-15/, response.body)
    assert_match(/900\.0.*1000\.0/, response.body)

    # Validate the structure of the historical table
    assert_select "table.table" do
      assert_select "thead tr th", "Fecha de Balance"
      assert_select "thead tr th", "Monto"

      assert_select "tbody tr" do |rows|
        assert_equal 2, rows.size
        # The table is reversed (newest first)
        assert_select rows[0], "td", "2026-02-15"
        assert_select rows[0], "td.text-success", text: /\$1,000\.00/

        assert_select rows[1], "td", "2026-01-10"
        assert_select rows[1], "td.text-success", text: /\$900\.00/
      end
    end
  end
end
