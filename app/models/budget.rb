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

  private

  def calculate_totals
    # Handle both persisted and new records
    items = budget_items.reject(&:marked_for_destruction?)
    income_items = items.select { |item| item.item_type == 'income' }
    expense_items = items.select { |item| item.item_type == 'expense' }

    self.total_income = income_items.sum { |item| item.amount.to_f }
    self.total_expenses = expense_items.sum { |item| item.amount.to_f }
    self.free_cash_flow = total_income - total_expenses
  end

  def end_date_after_start_date
    return unless start_date && end_date

    errors.add(:end_date, 'debe ser posterior a la fecha de inicio') if end_date < start_date
  end
end
