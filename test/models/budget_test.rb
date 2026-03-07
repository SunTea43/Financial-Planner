require "test_helper"

class BudgetTest < ActiveSupport::TestCase
  test "build_clone_for_next_period increments dates and copies items" do
    budget = budgets(:one)
    budget.update!(periodicity: "monthly", start_date: Date.new(2026, 1, 1), end_date: Date.new(2026, 1, 31))

    item = budget.budget_items.first
    item.update!(item_type: "income", name: "Salary", amount: 1000)

    # Let's clean up any invalid fixtures
    budget.budget_items.where.not(id: item.id).destroy_all

    cloned = budget.build_clone_for_next_period

    assert_equal Date.new(2026, 2, 1), cloned.start_date
    assert_equal Date.new(2026, 2, 28), cloned.end_date
    assert_equal "#{budget.name} (Copia)", cloned.name

    assert_equal budget.budget_items.count, cloned.budget_items.reject(&:marked_for_destruction?).select { |i| %w[income expense].include?(i.item_type) && i.name.present? }.size

    cloned_item = cloned.budget_items.find { |i| i.name == "Salary" }
    assert_not_nil cloned_item
    assert_equal "income", cloned_item.item_type
    assert_equal 1000, cloned_item.amount
    assert_nil cloned_item.id # Should be a new unpersisted record
  end
end
