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
class Account < ApplicationRecord
  belongs_to :user
  has_many :balance_sheets, dependent: :nullify
  has_many :budgets, dependent: :nullify

  validates :name, presence: true
  validates :account_type, presence: true

  ACCOUNT_TYPES = %w[checking savings investment credit_card loan investment_retirement other].freeze

  validates :account_type, inclusion: { in: ACCOUNT_TYPES }
end
