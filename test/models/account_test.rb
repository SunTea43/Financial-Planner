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
  test "sets default preferred currency" do
    account = Account.new(user: users(:one), name: "Cuenta COP", account_type: "checking")

    assert account.valid?
    assert_equal "COP", account.preferred_currency
  end

  test "rejects unsupported preferred currency" do
    account = Account.new(user: users(:one), name: "Cuenta invalida", account_type: "checking", preferred_currency: "XXX")

    assert_not account.valid?
    assert account.errors[:preferred_currency].present?
  end

  test "returns format options for preferred currency" do
    account = accounts(:one)
    account.preferred_currency = "JPY"

    assert_equal "JPY", account.currency_format_options[:unit]
    assert_equal 0, account.currency_format_options[:precision]
  end
end
