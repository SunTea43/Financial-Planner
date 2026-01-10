class Liability < ApplicationRecord
  belongs_to :balance_sheet

  validates :name, presence: true
  validates :liability_type, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  LIABILITY_TYPES = %w[short_term long_term].freeze

  validates :liability_type, inclusion: { in: LIABILITY_TYPES }
end
