class BudgetItem < ApplicationRecord
  belongs_to :budget

  validates :name, presence: true
  validates :item_type, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  ITEM_TYPES = %w[income expense].freeze

  validates :item_type, inclusion: { in: ITEM_TYPES }

  scope :income, -> { where(item_type: 'income') }
  scope :expense, -> { where(item_type: 'expense') }
end
