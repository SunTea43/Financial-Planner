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
    post data_export_url
    assert_response :success
    assert_equal "application/json", response.media_type

    data = JSON.parse(response.body)
    assert data.key?("version")
    assert data.key?("accounts")
    assert data.key?("balance_sheets")
    assert data.key?("budgets")
  end
end
