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

  test "projection includes same_installment_periods calculation" do
    plan = savings_plans(:one)
    projection = plan.projection

    assert projection.key?(:same_installment_periods)
    assert projection.key?(:same_installment_months_saved)
    assert projection.key?(:same_installment_days_saved)
    assert projection[:same_installment_periods] <= projection[:installments]
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

  test "total_saved aggregates savings plan entries" do
    plan = savings_plans(:one)
    total = plan.total_saved
    assert_equal 20000.00, total.to_f
  end

  test "progress_percentage calculates correctly" do
    plan = savings_plans(:one)
    # total saved is 20000, goal is 120000
    # 20000 / 120000 * 100 = 16.7%
    progress = plan.progress_percentage
    assert_equal 16.7, progress
  end

  test "months_until_goal_at_current_pace calculates projection" do
    plan = savings_plans(:one)
    # With 20000 saved and average of 20000/month, should be 5 months to 120000
    months = plan.months_until_goal_at_current_pace
    assert months > 0
    assert months <= plan.total_installments
  end
end
