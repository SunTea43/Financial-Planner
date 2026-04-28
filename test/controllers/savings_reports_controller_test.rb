require "test_helper"

class ReportsSavingsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get savings reports from reports savings path" do
    get savings_reports_path
    assert_response :success
  end

  test "should show all user plans in summary" do
    get savings_reports_path
    assert_response :success

    assert_select "table" do
      assert_select "tbody tr", count: 1
    end
  end
end
