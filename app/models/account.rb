class Account < ApplicationRecord
  belongs_to :user
  has_many :balance_sheets, dependent: :nullify
  has_many :budgets, dependent: :nullify

  validates :name, presence: true
  validates :account_type, presence: true

  ACCOUNT_TYPES = %w[checking savings investment credit_card loan investment_retirement other].freeze

  validates :account_type, inclusion: { in: ACCOUNT_TYPES }
end
