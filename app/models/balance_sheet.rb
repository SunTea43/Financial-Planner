# == Schema Information
#
# Table name: balance_sheets
#
#  id                :bigint           not null, primary key
#  user_id           :bigint           not null
#  account_id        :bigint
#  recorded_at       :datetime         not null
#  total_assets      :decimal(15, 2)   default(0.0)
#  total_liabilities :decimal(15, 2)   default(0.0)
#  net_worth         :decimal(15, 2)   default(0.0)
#  notes             :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_balance_sheets_on_account_id               (account_id)
#  index_balance_sheets_on_recorded_at              (recorded_at)
#  index_balance_sheets_on_user_id                  (user_id)
#  index_balance_sheets_on_user_id_and_recorded_at  (user_id,recorded_at)
#
class BalanceSheet < ApplicationRecord
  belongs_to :user
  belongs_to :account, optional: true
  has_many :assets, dependent: :destroy
  has_many :liabilities, dependent: :destroy

  validates :recorded_at, presence: true

  before_save :calculate_totals

  accepts_nested_attributes_for :assets, allow_destroy: true,
    reject_if: proc { |attrs| attrs.except("id", "position", "_destroy").values.all?(&:blank?) }
  accepts_nested_attributes_for :liabilities, allow_destroy: true,
    reject_if: proc { |attrs| attrs.except("id", "position", "_destroy").values.all?(&:blank?) }

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
    self.total_assets = assets.reject(&:marked_for_destruction?).map(&:amount).compact.sum || 0.0
    self.total_liabilities = liabilities.reject(&:marked_for_destruction?).map(&:amount).compact.sum || 0.0
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
