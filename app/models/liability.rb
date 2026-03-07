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
class Liability < BalanceSheetItem
  enum :item_type, {
    short_term: "short_term",
    long_term: "long_term"
  }
  translate_enum :item_type
end
