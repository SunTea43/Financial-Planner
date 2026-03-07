# == Schema Information
#
# Table name: accounts
#
#  id           :bigint           not null, primary key
#  user_id      :bigint           not null
#  name         :string           not null
#  account_type :string           not null
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_accounts_on_user_id                   (user_id)
#  index_accounts_on_user_id_and_account_type  (user_id,account_type)
#
require "test_helper"

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
