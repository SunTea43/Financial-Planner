class Asset < BalanceSheetItem
  ASSET_TYPES = %w[liquid fixed].freeze
  CATEGORIES = {
    liquid: %w[cash savings checking money_market],
    fixed: %w[real_estate vehicles equipment investments other]
  }.freeze

  validates :item_type, inclusion: { in: ASSET_TYPES }
end
