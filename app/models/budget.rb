# == Schema Information
#
# Table name: budgets
#
#  id             :bigint           not null, primary key
#  user_id        :bigint           not null
#  account_id     :bigint
#  name           :string           not null
#  periodicity    :string           default("monthly"), not null
#  start_date     :date             not null
#  end_date       :date             not null
#  total_income   :decimal(15, 2)   default(0.0)
#  total_expenses :decimal(15, 2)   default(0.0)
#  free_cash_flow :decimal(15, 2)   default(0.0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_budgets_on_account_id              (account_id)
#  index_budgets_on_periodicity             (periodicity)
#  index_budgets_on_user_id                 (user_id)
#  index_budgets_on_user_id_and_start_date  (user_id,start_date)
#
class Budget < ApplicationRecord
  belongs_to :user
  belongs_to :account, optional: true
  has_many :budget_items, dependent: :destroy

  validates :name, presence: true
  validates :periodicity, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  PERIODICITIES = %w[daily weekly monthly quarterly yearly].freeze

  validates :periodicity, inclusion: { in: PERIODICITIES }

  accepts_nested_attributes_for :budget_items, allow_destroy: true

  before_save :calculate_totals

  scope :by_account, ->(account_id) { where(account_id: account_id) if account_id.present? }
  scope :by_periodicity, ->(period) { where(periodicity: period) if period.present? }

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
