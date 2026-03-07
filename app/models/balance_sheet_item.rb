require "translate_enum/active_record"

class BalanceSheetItem < ApplicationRecord
  belongs_to :balance_sheet

  validates :name, presence: true
  validates :item_type, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  default_scope { order(position: :asc, created_at: :asc) }
end
