class ExchangeRate < ApplicationRecord
  validates :base_currency, :quote_currency, :fetched_at, :source, presence: true
  validates :rate, numericality: { greater_than: 0 }

  scope :for_pair, ->(base_currency, quote_currency) {
    where(base_currency: base_currency, quote_currency: quote_currency)
  }

  def self.latest_rate(base_currency:, quote_currency:)
    return BigDecimal("1") if base_currency == quote_currency

    for_pair(base_currency, quote_currency)
      .order(fetched_at: :desc, id: :desc)
      .limit(1)
      .pick(:rate)
  end
end
