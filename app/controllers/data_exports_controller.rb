class DataExportsController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def create
    data = gather_export_data
    send_data JSON.pretty_generate(data),
              filename: "financial_planner_export_#{Time.now.strftime('%Y%m%d%H%M%S')}.json",
              type: "application/json"
  end

  private

  def gather_export_data
    {
      version: 1,
      exported_at: Time.current,
      accounts: current_user.accounts.as_json,
      balance_sheets: current_user.balance_sheets.includes(:assets, :liabilities).map do |bs|
        bs.as_json(include: [ :assets, :liabilities ])
      end,
      budgets: current_user.budgets.includes(:budget_items).map do |budget|
        budget.as_json(include: :budget_items)
      end
    }
  end
end
