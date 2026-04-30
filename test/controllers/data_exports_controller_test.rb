require "test_helper"

class DataExportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get show view" do
    get data_export_url
    assert_response :success
  end

  test "should download export file" do
    @user.update!(preferred_currency: "USD")

    post data_export_url
    assert_response :success
    assert_equal "application/json", response.media_type

    data = JSON.parse(response.body)
    assert data.key?("version")
    assert data.key?("accounts")
    assert data.key?("balance_sheets")
    assert data.key?("budgets")
    assert data.key?("savings_plans")
    assert data.key?("user_settings")
    assert_equal "USD", data.dig("user_settings", "preferred_currency")

    exported_plan = data["savings_plans"].find { |plan| plan["name"] == savings_plans(:one).name }
    assert_not_nil exported_plan
    assert_equal savings_plans(:one).goal_amount.to_s, exported_plan["goal_amount"].to_s
  end
end
