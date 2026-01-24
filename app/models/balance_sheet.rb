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

  def previous_balance_sheet
    user.balance_sheets
        .where(account_id: account_id)
        .where("recorded_at < ?", recorded_at)
        .order(recorded_at: :desc)
        .first
  end

  def comparison_with_previous
    prev = previous_balance_sheet
    return nil unless prev

    {
      total_assets_diff: total_assets - prev.total_assets,
      total_liabilities_diff: total_liabilities - prev.total_liabilities,
      net_worth_diff: net_worth - prev.net_worth,
      assets: compare_items(assets, prev.assets),
      liabilities: compare_items(liabilities, prev.liabilities)
    }
  end

  private

  def calculate_totals
    self.total_assets = assets.sum(:amount) || 0.0
    self.total_liabilities = liabilities.sum(:amount) || 0.0
    self.net_worth = total_assets - total_liabilities
  end

  def compare_items(current_items, previous_items)
    current_map = current_items.index_by(&:name)
    prev_map = previous_items.index_by(&:name)
    all_names = (current_map.keys + prev_map.keys).uniq

    all_names.map do |name|
      curr = current_map[name]
      prev = prev_map[name]

      current_amount = curr&.amount || 0.0
      previous_amount = prev&.amount || 0.0

      {
        name: name,
        current_amount: current_amount,
        previous_amount: previous_amount,
        diff: current_amount - previous_amount
      }
    end.sort_by { |i| -i[:diff].abs }
  end
end
