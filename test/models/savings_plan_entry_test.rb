require "test_helper"

class SavingsPlanEntryTest < ActiveSupport::TestCase
  test "savings_plan_entry validates presence of amount and date" do
    entry = SavingsPlanEntry.new(
      savings_plan: savings_plans(:one),
      amount: nil,
      entry_date: nil
    )

    assert_not entry.valid?
    assert entry.errors.added?(:amount, :blank)
    assert entry.errors.added?(:entry_date, :blank)
  end

  test "savings_plan_entry validates amount is positive" do
    entry = savings_plan_entries(:one)
    entry.amount = -100
    assert_not entry.valid?
  end

  test "total_saved sums all entries for a plan" do
    plan = savings_plans(:one)
    total = SavingsPlanEntry.total_saved(plan)
    assert_equal 20000.00, total.to_f
  end

  test "average_monthly_savings calculates correct monthly average" do
    plan = savings_plans(:one)
    avg = SavingsPlanEntry.average_monthly_savings(plan)
    # Two entries from Feb 1 to Mar 1 (1 month)
    # 20000 / 1 month = 20000
    assert avg > 0
    assert avg.to_f >= 10000.0
  end
end
