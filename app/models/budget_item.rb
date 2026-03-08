# == Schema Information
#
# Table name: budget_items
#
#  id          :bigint           not null, primary key
#  budget_id   :bigint           not null
#  name        :string           not null
#  item_type   :string           not null
#  amount      :decimal(15, 2)   not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  position    :integer
#
# Indexes
#
#  index_budget_items_on_budget_id                (budget_id)
#  index_budget_items_on_budget_id_and_item_type  (budget_id,item_type)
#
require "translate_enum/active_record"

class BudgetItem < ApplicationRecord
  belongs_to :budget

  validates :name, presence: true
  validates :item_type, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  enum :item_type, {
    income: "income",
    expense: "expense"
  }
  translate_enum :item_type

  default_scope { order(position: :asc, created_at: :asc) }
end
