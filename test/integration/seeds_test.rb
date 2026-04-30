require "test_helper"

class SeedsTest < ActiveSupport::TestCase
  SEED_EMAIL = "seed.user@example.com".freeze

  setup do
    remove_seed_user
  end

  teardown do
    remove_seed_user
  end

  test "seeds create a user with account, last month balance, budget, and savings plan" do
    Rails.application.load_seed

    last_month_start = Date.current.last_month.beginning_of_month
    last_month_end = Date.current.last_month.end_of_month
    last_month_recorded_at = last_month_end.to_time.change(hour: 12)

    user = User.find_by!(email: SEED_EMAIL)
    account = user.accounts.find_by!(name: "Cuenta Principal", account_type: "checking")

    balance_sheet = user.balance_sheets.find_by!(account: account, recorded_at: last_month_recorded_at)
    assert balance_sheet.assets.exists?
    assert balance_sheet.liabilities.exists?

    budget = user.budgets.find_by!(
      name: "Presupuesto #{last_month_start.strftime('%Y-%m')}",
      start_date: last_month_start,
      end_date: last_month_end,
      periodicity: "monthly"
    )
    assert budget.budget_items.exists?

    savings_plan = user.savings_plans.find_by!(
      name: "Fondo de emergencia",
      start_date: last_month_start,
      target_date: last_month_end.next_month.end_of_month
    )
    assert savings_plan.entries.where(entry_date: last_month_end).exists?
  end

  test "seeds are idempotent for seeded records" do
    Rails.application.load_seed
    Rails.application.load_seed

    last_month_start = Date.current.last_month.beginning_of_month
    last_month_end = Date.current.last_month.end_of_month
    last_month_recorded_at = last_month_end.to_time.change(hour: 12)

    assert_equal 1, User.where(email: SEED_EMAIL).count

    user = User.find_by!(email: SEED_EMAIL)
    account = user.accounts.find_by!(name: "Cuenta Principal", account_type: "checking")

    assert_equal 1, user.accounts.where(name: "Cuenta Principal", account_type: "checking").count
    assert_equal 1, user.balance_sheets.where(account: account, recorded_at: last_month_recorded_at).count
    assert_equal 1, user.budgets.where(
      name: "Presupuesto #{last_month_start.strftime('%Y-%m')}",
      start_date: last_month_start,
      end_date: last_month_end,
      periodicity: "monthly"
    ).count
    assert_equal 1, user.savings_plans.where(
      name: "Fondo de emergencia",
      start_date: last_month_start,
      target_date: last_month_end.next_month.end_of_month
    ).count
  end

  private

  def remove_seed_user
    User.find_by(email: SEED_EMAIL)&.destroy!
  end
end
