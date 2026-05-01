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

  test "dashboard shows current user savings plan info" do
    sign_in @user
    plan = savings_plans(:one)

    get dashboard_index_url
    assert_response :success

    assert_select "h5", text: "Planes de Ahorro"
    assert_match plan.name, response.body
  end

  test "dashboard does not show another user savings plans" do
    sign_in @user
    other_plan = savings_plans(:two)

    get dashboard_index_url
    assert_response :success

    assert_no_match other_plan.name, response.body
  end

  test "dashboard reflects savings plans count" do
    sign_in @user
    @user.savings_plans.create!(
      name: "Meta adicional",
      goal_amount: 50000,
      start_date: Date.current,
      target_date: Date.current.advance(months: 10),
      annual_interest_rate: 7.5
    )

    get dashboard_index_url
    assert_response :success

    assert_select "h5.card-title", text: "Planes de Ahorro"
    assert_select "h2.text-warning", text: "2"
  end

  test "authenticated layout uses sidebar for main navigation" do
    sign_in @user

    get dashboard_index_url
    assert_response :success

    assert_select "#mainSidebar .list-group a[href='#{authenticated_root_path}']", count: 1
    assert_select "#mainSidebar .list-group a[href='#{accounts_path}']", count: 1
    assert_select "#mainSidebar .list-group a[href='#{balance_sheets_path}']", count: 1
    assert_select "#mainSidebar .list-group a[href='#{budgets_path}']", count: 1
    assert_select "#mainSidebar .list-group a[href='#{savings_plans_path}']", count: 1
    assert_select "#mainSidebar .list-group a[href='#{reports_path}']", count: 1

    assert_select "nav .dropdown-menu a[href='#{edit_user_registration_path}']", count: 1
    assert_select "nav .dropdown-menu a[href='#{data_export_path}']", count: 1
    assert_select "nav .dropdown-menu a[href='#{new_data_import_path}']", count: 1

    assert_select "nav a[href='#{accounts_path}']", count: 0
    assert_select "nav a[href='#{balance_sheets_path}']", count: 0
    assert_select "nav a[href='#{budgets_path}']", count: 0
    assert_select "nav a[href='#{savings_plans_path}']", count: 0
    assert_select "nav a[href='#{reports_path}']", count: 0
  end
end
