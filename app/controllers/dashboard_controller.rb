class DashboardController < ApplicationController
  def index
    @accounts = current_user.accounts.limit(5)
    @latest_balance_sheet = current_user.balance_sheets.latest.first
    @latest_budgets = current_user.budgets.order(start_date: :desc).limit(3)

    @total_accounts = current_user.accounts.count
    @total_balance_sheets = current_user.balance_sheets.count
    @total_budgets = current_user.budgets.count

    if @latest_balance_sheet
      @current_net_worth = @latest_balance_sheet.net_worth
      @previous_balance_sheet = current_user.balance_sheets.where('recorded_at < ?', @latest_balance_sheet.recorded_at).latest.first
      if @previous_balance_sheet
        @net_worth_change = @current_net_worth - @previous_balance_sheet.net_worth
      end
    end
  end
end
