# == Schema Information
#
# Table name: balance_sheet_items
#
#  id               :bigint           not null, primary key
#  balance_sheet_id :bigint           not null
#  name             :string           not null
#  item_type        :string           not null
#  category         :string
#  amount           :decimal(15, 2)   not null
#  description      :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  position         :integer
#  type             :string
#
# Indexes
#
#  index_balance_sheet_items_on_balance_sheet_id                (balance_sheet_id)
#  index_balance_sheet_items_on_balance_sheet_id_and_item_type  (balance_sheet_id,item_type)
#  index_balance_sheet_items_on_category                        (category)
#
class Asset < BalanceSheetItem
  ASSET_TYPES = %w[liquid fixed].freeze
  CATEGORIES = {
    liquid: %w[cash savings checking money_market],
    fixed: %w[real_estate vehicles equipment investments other]
  }.freeze

  validates :item_type, inclusion: { in: ASSET_TYPES }
end
