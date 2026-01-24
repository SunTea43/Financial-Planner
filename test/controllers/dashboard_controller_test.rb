require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  test "should get index when authenticated" do
    sign_in @user
    get dashboard_index_url
    assert_response :success
  end

  test "should redirect to sign in when not authenticated" do
    get dashboard_index_url
    assert_redirected_to new_user_session_path
  end
end
