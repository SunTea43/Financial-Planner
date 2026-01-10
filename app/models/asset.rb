class Asset < ApplicationRecord
  belongs_to :balance_sheet

  validates :name, presence: true
  validates :asset_type, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  ASSET_TYPES = %w[liquid fixed].freeze
  CATEGORIES = {
    liquid: %w[cash savings checking money_market],
    fixed: %w[real_estate vehicles equipment investments other]
  }.freeze

  validates :asset_type, inclusion: { in: ASSET_TYPES }
end
