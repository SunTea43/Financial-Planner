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
require "test_helper"

class BudgetItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
