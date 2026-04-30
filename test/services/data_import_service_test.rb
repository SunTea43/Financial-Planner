require "test_helper"

class DataImportServiceTest < ActiveSupport::TestCase
  setup do
    @user = users(:one) # Using fixture user
  end

  test "imports accounts successfully" do
    data = {
      "accounts" => [
        {
          "id" => 999,
          "name" => "Imported Checking",
          "account_type" => "checking",
          "description" => "A checking account",
          "created_at" => "2023-01-01T12:00:00Z",
          "updated_at" => "2023-01-01T12:00:00Z"
        }
      ]
    }

    assert_difference("@user.accounts.count") do
      DataImportService.new(@user, data).call
    end

    imported_account = @user.accounts.last
    assert_equal "Imported Checking", imported_account.name
    assert_equal "checking", imported_account.account_type
    assert_equal "A checking account", imported_account.description
  end

  test "imports account preferred currency from legacy user settings" do
    data = {
      "user_settings" => {
        "preferred_currency" => "EUR"
      },
      "accounts" => [
        {
          "id" => 1001,
          "name" => "Legacy Currency Account",
          "account_type" => "checking"
        }
      ]
    }

    DataImportService.new(@user, data).call

    assert_equal "EUR", @user.accounts.find_by(name: "Legacy Currency Account")&.preferred_currency
  end

  test "imports account preferred currency from account payload" do
    data = {
      "accounts" => [
        {
          "id" => 1002,
          "name" => "Explicit Currency Account",
          "account_type" => "checking",
          "preferred_currency" => "USD"
        }
      ]
    }

    DataImportService.new(@user, data).call

    assert_equal "USD", @user.accounts.find_by(name: "Explicit Currency Account")&.preferred_currency
  end

  test "imports balance sheets and items successfully" do
    data = {
      "accounts" => [
        {
          "id" => 999,
          "name" => "Imported Savings",
          "account_type" => "savings"
        }
      ],
      "balance_sheets" => [
        {
          "id" => 888,
          "account_id" => 999,
          "recorded_at" => "2023-01-01T12:00:00Z",
          "total_assets" => "1000.0",
          "total_liabilities" => "500.0",
          "net_worth" => "500.0",
          "notes" => "Initial balance",
          "assets" => [
            {
              "name" => "Cash",
              "item_type" => "liquid",
              "amount" => "1000.0",
              "position" => 1
            }
          ],
          "liabilities" => [
            {
              "name" => "Credit Card",
              "item_type" => "short_term",
              "amount" => "500.0",
              "position" => 1
            }
          ]
        }
      ]
    }

    assert_difference("@user.accounts.count", 1) do
      assert_difference("@user.balance_sheets.count", 1) do
        assert_difference("Asset.count", 1) do
          assert_difference("Liability.count", 1) do
            DataImportService.new(@user, data).call
          end
        end
      end
    end

    bs = @user.balance_sheets.last
    assert_equal @user.accounts.last.id, bs.account_id
    assert_equal "Initial balance", bs.notes
    assert_equal 1000.0, bs.total_assets
    assert_equal "Cash", bs.assets.first.name
    assert_equal 1000.0, bs.assets.first.amount
    assert_equal "Credit Card", bs.liabilities.first.name
  end

  test "imports budgets and items successfully" do
    data = {
      "budgets" => [
        {
          "id" => 777,
          "name" => "Monthly Tech",
          "periodicity" => "monthly",
          "start_date" => "2023-01-01",
          "end_date" => "2023-01-31",
          "total_income" => "3000.0",
          "total_expenses" => "2000.0",
          "free_cash_flow" => "1000.0",
          "budget_items" => [
            {
              "name" => "Salary",
              "item_type" => "income",
              "amount" => "3000.0"
            },
            {
              "name" => "Rent",
              "item_type" => "expense",
              "amount" => "2000.0"
            }
          ]
        }
      ]
    }

    assert_difference("@user.budgets.count", 1) do
      assert_difference("BudgetItem.count", 2) do
        DataImportService.new(@user, data).call
      end
    end

    budget = @user.budgets.last
    assert_equal "Monthly Tech", budget.name
    assert_equal "monthly", budget.periodicity
    assert_equal Date.new(2023, 1, 1), budget.start_date
    assert_equal 3000.0, budget.total_income

    assert_equal 1, budget.budget_items.where(item_type: "income").count
    assert_equal 1, budget.budget_items.where(item_type: "expense").count
    assert_equal "Salary", budget.budget_items.find_by(item_type: "income").name
  end

  test "imports savings plans successfully" do
    data = {
      "savings_plans" => [
        {
          "id" => 666,
          "name" => "Emergency Fund",
          "goal_amount" => "150000.0",
          "initial_capital" => "10000.0",
          "start_date" => "2026-01-01",
          "target_date" => "2026-12-31",
          "annual_interest_rate" => "7.5"
        }
      ]
    }

    assert_difference("@user.savings_plans.count", 1) do
      DataImportService.new(@user, data).call
    end

    plan = @user.savings_plans.last
    assert_equal "Emergency Fund", plan.name
    assert_equal 150000.0, plan.goal_amount
    assert_equal 10000.0, plan.initial_capital
    assert_equal Date.new(2026, 1, 1), plan.start_date
    assert_equal Date.new(2026, 12, 31), plan.target_date
    assert_equal 7.5, plan.annual_interest_rate
  end
end
