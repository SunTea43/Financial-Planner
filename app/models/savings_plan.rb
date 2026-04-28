class SavingsPlan < ApplicationRecord
  belongs_to :user
  has_many :entries, class_name: "SavingsPlanEntry", dependent: :destroy

  validates :name, presence: true
  validates :goal_amount, numericality: { greater_than: 0 }
  validates :annual_interest_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :start_date, :target_date, presence: true
  validate :target_date_after_start_date

  before_validation :set_default_start_date

  scope :recent, -> { order(created_at: :desc) }

  def total_saved
    SavingsPlanEntry.total_saved(self)
  end

  def average_monthly_savings
    SavingsPlanEntry.average_monthly_savings(self)
  end

  def progress_percentage
    saved = total_saved
    return 0 if saved <= 0

    ((saved / goal_amount.to_d) * 100).round(1)
  end

  def months_until_goal_at_current_pace
    avg = average_monthly_savings
    return 0 if avg <= 0

    ((goal_amount.to_d - total_saved) / avg).ceil.to_i
  end

  def total_installments
    months = (target_date.year * 12 + target_date.month) - (start_date.year * 12 + start_date.month) + 1
    [ months, 1 ].max
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

    # New scenario: keep same installment as without-interest, but apply interest accrual
    same_installment_periods = months_to_reach_goal_with_fixed_installment(installment_without_interest, monthly_rate)
    days_saved = (installments - same_installment_periods) * 30.4

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
      same_installment_periods: same_installment_periods,
      same_installment_months_saved: installments - same_installment_periods,
      same_installment_days_saved: days_saved.round.to_i,
      chart: chart_projection_data(installment_without_interest, installment_with_interest, monthly_rate, installments, same_installment_periods)
    }
  end

  def months_to_reach_goal_with_fixed_installment(installment, monthly_rate)
    return 0 if installment <= 0

    return (goal_amount.to_d / installment).ceil.to_i if monthly_rate.zero?

    # Solve: installment * ((1+r)^n - 1) / r = goal_amount
    # n = log(goal_amount * r / installment + 1) / log(1 + r)
    numerator = (goal_amount.to_d * monthly_rate) / installment + 1
    return 1 if numerator <= 0

    (Math.log(numerator.to_f) / Math.log((1 + monthly_rate.to_f))).ceil.to_i
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

  def chart_projection_data(installment_without_interest, installment_with_interest, monthly_rate, installments, same_installment_periods)
    labels = []
    without_interest = []
    with_interest = []
    same_installment_with_interest = []
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

      # Same installment as without interest, but with interest accrual
      if period <= same_installment_periods
        same_inst_value = if monthly_rate.zero?
          installment_without_interest * period
        else
          installment_without_interest * ((((1 + monthly_rate)**period) - 1) / monthly_rate)
        end
        same_installment_with_interest << safe_money(same_inst_value)
      else
        same_installment_with_interest << safe_money(goal_amount)
      end

      goal_line << safe_money(goal_amount)
    end

    {
      labels: labels,
      without_interest: without_interest,
      with_interest: with_interest,
      same_installment_with_interest: same_installment_with_interest,
      goal: goal_line
    }
  end

  def safe_money(value)
    value.to_d.round(2)
  end
end
