class SavingsReportsController < ApplicationController
  def index
    @plans_summary = current_user.savings_plans.map do |plan|
      {
        plan: plan,
        total_saved: plan.total_saved,
        progress_percentage: plan.progress_percentage,
        average_monthly: plan.average_monthly_savings,
        months_to_goal: plan.months_until_goal_at_current_pace,
        status: calculate_status(plan)
      }
    end
  end

  private

  def calculate_status(plan)
    case plan.progress_percentage
    when 0...25
      :at_risk
    when 25...50
      :on_track_low
    when 50...75
      :on_track_medium
    when 75...100
      :on_track_high
    else
      :completed
    end
  end
end
