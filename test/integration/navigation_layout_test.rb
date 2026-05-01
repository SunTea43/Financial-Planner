require "test_helper"

class NavigationLayoutTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "authenticated users see sidebar navigation and compact navbar actions" do
    sign_in @user

    get dashboard_index_url
    assert_response :success

    assert_select "#mainSidebarMobile.offcanvas.offcanvas-start.d-lg-none", count: 1
    assert_select "#mainSidebarDesktop.collapse.collapse-horizontal.show", count: 1
    assert_select "#mainSidebarDesktop .list-group a[href='#{authenticated_root_path}']", count: 1
    assert_select "#mainSidebarDesktop .list-group a[href='#{accounts_path}']", count: 1
    assert_select "#mainSidebarDesktop .list-group a[href='#{balance_sheets_path}']", count: 1
    assert_select "#mainSidebarDesktop .list-group a[href='#{budgets_path}']", count: 1
    assert_select "#mainSidebarDesktop .list-group a[href='#{savings_plans_path}']", count: 1
    assert_select "#mainSidebarDesktop .list-group a[href='#{reports_path}']", count: 1

    assert_select "nav button[data-bs-toggle='offcanvas'][data-bs-target='#mainSidebarMobile'][aria-controls='mainSidebarMobile']", count: 1
    assert_select "nav button[data-bs-toggle='collapse'][data-bs-target='#mainSidebarDesktop'][aria-controls='mainSidebarDesktop']", count: 1

    assert_select "nav .dropdown-menu a[href='#{edit_user_registration_path}']", count: 1
    assert_select "nav .dropdown-menu a[href='#{data_export_path}']", count: 1
    assert_select "nav .dropdown-menu a[href='#{new_data_import_path}']", count: 1

    assert_select "nav a[href='#{accounts_path}']", count: 0
    assert_select "nav a[href='#{balance_sheets_path}']", count: 0
    assert_select "nav a[href='#{budgets_path}']", count: 0
    assert_select "nav a[href='#{savings_plans_path}']", count: 0
    assert_select "nav a[href='#{reports_path}']", count: 0
  end

  test "sidebar marks current section as active" do
    sign_in @user

    get budgets_path
    assert_response :success

    assert_select "#mainSidebarDesktop .list-group a[href='#{budgets_path}'].active", count: 1
    assert_select "#mainSidebarDesktop .list-group a[href='#{accounts_path}'].active", count: 0
  end

  test "guests do not see sidebar or authenticated navbar" do
    get root_path
    assert_response :success

    assert_select "#mainSidebarMobile", count: 0
    assert_select "#mainSidebarDesktop", count: 0
    assert_select "nav button[data-bs-target='#mainSidebarMobile']", count: 0
    assert_select "nav button[data-bs-target='#mainSidebarDesktop']", count: 0
    assert_select "nav .dropdown-menu", count: 0
  end
end
