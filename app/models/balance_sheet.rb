class BalanceSheet < ApplicationRecord
  belongs_to :user
  belongs_to :account, optional: true
  has_many :assets, dependent: :destroy
  has_many :liabilities, dependent: :destroy

  validates :recorded_at, presence: true

  before_save :calculate_totals

  accepts_nested_attributes_for :assets, allow_destroy: true
  accepts_nested_attributes_for :liabilities, allow_destroy: true

  scope :by_account, ->(account_id) { where(account_id: account_id) if account_id.present? }
  scope :latest, -> { order(recorded_at: :desc) }

  private

  def calculate_totals
    self.total_assets = assets.sum(:amount) || 0.0
    self.total_liabilities = liabilities.sum(:amount) || 0.0
    self.net_worth = total_assets - total_liabilities
  end
end
