require "test_helper"

class SavingsPlanTest < ActiveSupport::TestCase
  test "projection returns installments and monthly quotas" do
    plan = savings_plans(:one)
    projection = plan.projection

    assert_equal 12, projection[:installments]
    assert projection[:installment_without_interest] > 0
    assert projection[:installment_with_interest] > 0
    assert_equal 12, projection[:chart][:labels].size
    assert_equal plan.goal_amount.to_d.round(2), projection[:chart][:goal].last
  end

  test "projection with interest should require lower installment" do
    plan = savings_plans(:one)
    projection = plan.projection

    assert projection[:installment_with_interest] < projection[:installment_without_interest]
    assert projection[:annual_cash_advantage] > 0
  end

  test "target date must be after or equal to start date" do
    plan = SavingsPlan.new(
      user: users(:one),
      name: "Meta invalida",
      goal_amount: 10000,
      start_date: Date.current,
      target_date: Date.yesterday,
      annual_interest_rate: 5
    )

    assert_not plan.valid?
    assert plan.errors.added?(:target_date, :after_start_date)
  end
end
