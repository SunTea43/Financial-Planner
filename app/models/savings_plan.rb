class SavingsPlan < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :goal_amount, numericality: { greater_than: 0 }
  validates :annual_interest_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :start_date, :target_date, presence: true
  validate :target_date_after_start_date

  before_validation :set_default_start_date

  scope :recent, -> { order(created_at: :desc) }

  def total_installments
    months = (target_date.year * 12 + target_date.month) - (start_date.year * 12 + start_date.month) + 1
    [months, 1].max
  end

  def projection
    installments = total_installments
    monthly_rate = annual_interest_rate.to_d / 100 / 12

    installment_without_interest = safe_money(goal_amount.to_d / installments)

    installment_with_interest = if monthly_rate.zero?
      installment_without_interest
    else
      growth_factor = (((1 + monthly_rate)**installments) - 1) / monthly_rate
      safe_money(goal_amount.to_d / growth_factor)
    end

    total_contributed_without_interest = safe_money(installment_without_interest * installments)
    total_contributed_with_interest = safe_money(installment_with_interest * installments)
    estimated_interest_earned = safe_money(goal_amount.to_d - total_contributed_with_interest)

    annual_outlay_without_interest = safe_money(installment_without_interest * 12)
    annual_outlay_with_interest = safe_money(installment_with_interest * 12)
    annual_cash_advantage = safe_money(annual_outlay_without_interest - annual_outlay_with_interest)

    {
      installments: installments,
      installment_without_interest: installment_without_interest,
      installment_with_interest: installment_with_interest,
      total_contributed_without_interest: total_contributed_without_interest,
      total_contributed_with_interest: total_contributed_with_interest,
      estimated_interest_earned: estimated_interest_earned,
      annual_outlay_without_interest: annual_outlay_without_interest,
      annual_outlay_with_interest: annual_outlay_with_interest,
      annual_cash_advantage: annual_cash_advantage,
      chart: chart_projection_data(installment_without_interest, installment_with_interest, monthly_rate, installments)
    }
  end

  private

  def set_default_start_date
    self.start_date ||= Date.current
  end

  def target_date_after_start_date
    return unless start_date && target_date

    return if target_date >= start_date

    errors.add(:target_date, :after_start_date)
  end

  def chart_projection_data(installment_without_interest, installment_with_interest, monthly_rate, installments)
    labels = []
    without_interest = []
    with_interest = []
    goal_line = []

    1.upto(installments) do |period|
      period_date = start_date.advance(months: period - 1)
      labels << I18n.l(period_date, format: :short)

      without_interest << safe_money(installment_without_interest * period)

      with_interest_value = if monthly_rate.zero?
        installment_with_interest * period
      else
        installment_with_interest * ((((1 + monthly_rate)**period) - 1) / monthly_rate)
      end
      with_interest << safe_money(with_interest_value)

      goal_line << safe_money(goal_amount)
    end

    {
      labels: labels,
      without_interest: without_interest,
      with_interest: with_interest,
      goal: goal_line
    }
  end

  def safe_money(value)
    value.to_d.round(2)
  end
end
