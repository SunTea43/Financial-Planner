require "test_helper"

class SavingsPlanEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @savings_plan = savings_plans(:one)
    sign_in @user
  end

  test "should get index" do
    get savings_plan_savings_plan_entries_url(@savings_plan)
    assert_response :success
  end

  test "should get new" do
    get new_savings_plan_savings_plan_entry_url(@savings_plan)
    assert_response :success
  end

  test "should create savings_plan_entry" do
    assert_difference("SavingsPlanEntry.count", 1) do
      post savings_plan_savings_plan_entries_url(@savings_plan), params: {
        savings_plan_entry: {
          entry_date: Date.current,
          amount: 5000.00,
          frequency: "manual",
          notes: "Test entry"
        }
      }
    end

    assert_redirected_to savings_plan_url(@savings_plan)
  end

  test "should show edit form" do
    entry = savings_plan_entries(:one)
    get edit_savings_plan_savings_plan_entry_url(@savings_plan, entry)
    assert_response :success
  end

  test "should update savings_plan_entry" do
    entry = savings_plan_entries(:one)
    patch savings_plan_savings_plan_entry_url(@savings_plan, entry), params: {
      savings_plan_entry: {
        amount: 12000.00
      }
    }

    assert_redirected_to savings_plan_url(@savings_plan)
    entry.reload
    assert_equal 12000.00, entry.amount
  end

  test "should destroy savings_plan_entry" do
    entry = savings_plan_entries(:one)
    assert_difference("SavingsPlanEntry.count", -1) do
      delete savings_plan_savings_plan_entry_url(@savings_plan, entry)
    end

    assert_redirected_to savings_plan_url(@savings_plan)
  end
end
