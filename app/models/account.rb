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
require "translate_enum/active_record"

class Account < ApplicationRecord
  DEFAULT_CURRENCY = "COP".freeze
  SUPPORTED_CURRENCIES = YAML.load_file(Rails.root.join("config/currencies.yml")).transform_values do |opts|
    opts.transform_keys(&:to_sym)
  end.freeze

  belongs_to :user
  has_many :balance_sheets, dependent: :nullify
  has_many :budgets, dependent: :nullify

  before_validation :set_default_preferred_currency

  validates :name, presence: true
  validates :account_type, presence: true
  validates :preferred_currency, inclusion: { in: SUPPORTED_CURRENCIES.keys }

  enum :account_type, {
    checking: "checking",
    savings: "savings",
    investment: "investment",
    credit_card: "credit_card",
    loan: "loan",
    investment_retirement: "investment_retirement",
    other: "other"
  }
  translate_enum :account_type

  def self.currency_options
    SUPPORTED_CURRENCIES.keys.map do |code|
      [ I18n.t("currencies.#{code}", default: code), code ]
    end
  end

  def currency_format_options
    SUPPORTED_CURRENCIES.fetch(preferred_currency, SUPPORTED_CURRENCIES[DEFAULT_CURRENCY])
  end

  private

  def set_default_preferred_currency
    self.preferred_currency = DEFAULT_CURRENCY if preferred_currency.blank?
  end
end
