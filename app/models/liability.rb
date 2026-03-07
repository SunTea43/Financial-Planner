class Liability < BalanceSheetItem
  LIABILITY_TYPES = %w[short_term long_term].freeze

  validates :item_type, inclusion: { in: LIABILITY_TYPES }
end
