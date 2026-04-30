# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "sets default preferred currency" do
    user = User.new(email: "currency-default@example.com", password: "password123")

    assert user.valid?
    assert_equal "COP", user.preferred_currency
  end

  test "rejects unsupported preferred currency" do
    user = User.new(email: "currency-invalid@example.com", password: "password123", preferred_currency: "XXX")

    assert_not user.valid?
    assert user.errors[:preferred_currency].present?
  end

  test "returns format options for preferred currency" do
    user = users(:one)
    user.preferred_currency = "JPY"

    assert_equal "JPY", user.currency_format_options[:unit]
    assert_equal 0, user.currency_format_options[:precision]
  end
end
