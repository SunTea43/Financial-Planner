require "translate_enum/active_record"

class Budget < ApplicationRecord
  belongs_to :user
  belongs_to :account, optional: true
  has_many :budget_items, dependent: :destroy

  validates :name, presence: true
  enum :periodicity, {
    daily: "daily",
    weekly: "weekly",
    monthly: "monthly",
    quarterly: "quarterly",
    yearly: "yearly"
  }, default: :monthly
  translate_enum :periodicity

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  accepts_nested_attributes_for :budget_items, allow_destroy: true

  before_save :calculate_totals

  scope :by_account, ->(account_id) { where(account_id: account_id) if account_id.present? }
  scope :by_periodicity, ->(period) { where(periodicity: period) if period.present? }

  def income_items
    budget_items.reject(&:marked_for_destruction?).select(&:income?)
  end

  def expense_items
    budget_items.reject(&:marked_for_destruction?).select(&:expense?)
  end

  def savings_ratio
    ratio(positive_free_cash_flow)
  end

  def investment_ratio
    # Treat positive free cash flow as available investment capacity.
    ratio(positive_free_cash_flow)
  end

  def expense_ratio
    ratio(total_expenses.to_f)
  end

  def essential_expense_ratio
    ratio(top_expense_category_total)
  end

  def debt_service_ratio
    ratio(uncategorized_expenses_total)
  end

  def discretionary_expense_ratio
    ratio([ total_expenses.to_f - top_expense_category_total, 0 ].max)
  end

  def build_clone_for_next_period
    cloned = self.dup

    if start_date && end_date
      duration = (end_date - start_date).to_i

      case periodicity
      when "daily"
        cloned.start_date = start_date + 1.day
        cloned.end_date = end_date + 1.day
      when "weekly"
        cloned.start_date = start_date + 1.week
        cloned.end_date = end_date + 1.week
      when "monthly"
        cloned.start_date = start_date + 1.month
        cloned.end_date = end_date + 1.month
      when "quarterly"
        cloned.start_date = start_date + 3.months
        cloned.end_date = end_date + 3.months
      when "yearly"
        cloned.start_date = start_date + 1.year
        cloned.end_date = end_date + 1.year
      else
        cloned.start_date = end_date + 1.day
        cloned.end_date = cloned.start_date + duration.days
      end
    end

    cloned.name = "#{self.name} (Copia)"

    budget_items.reject(&:marked_for_destruction?).each do |item|
      cloned.budget_items.build(item.attributes.except("id", "budget_id", "created_at", "updated_at"))
    end

    cloned
  end

  private

  def ratio(numerator)
    income = total_income.to_f
    return 0.0 if income <= 0

    numerator.to_f / income
  end

  def positive_free_cash_flow
    [ free_cash_flow.to_f, 0.0 ].max
  end

  def top_expense_category_total
    grouped = expense_items.group_by { |item| item.category.presence || "__uncategorized__" }
    grouped.values.map { |items| items.sum { |item| item.amount.to_f } }.max.to_f
  end

  def uncategorized_expenses_total
    expense_items.select { |item| item.category.blank? }.sum { |item| item.amount.to_f }
  end

  def calculate_totals
    # Handle both persisted and new records
    items = budget_items.reject(&:marked_for_destruction?)
    income_items = items.select { |item| item.item_type == "income" }
    expense_items = items.select { |item| item.item_type == "expense" }

    self.total_income = income_items.sum { |item| item.amount.to_f }
    self.total_expenses = expense_items.sum { |item| item.amount.to_f }
    self.free_cash_flow = total_income - total_expenses
  end

  def end_date_after_start_date
    return unless start_date && end_date

    errors.add(:end_date, "debe ser posterior a la fecha de inicio") if end_date < start_date
  end
end
