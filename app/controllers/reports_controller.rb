class ReportsController < ApplicationController
  def index
  end

  def balance_sheet
    @account_id = params[:account_id]
    @start_date = params[:start_date].presence
    @end_date = params[:end_date].presence

    @balance_sheets = current_user.balance_sheets.includes(:account, :assets, :liabilities)
                                   .latest

    @balance_sheets = @balance_sheets.by_account(@account_id) if @account_id.present?

    if @start_date.present?
      @balance_sheets = @balance_sheets.where("recorded_at >= ?", Date.parse(@start_date))
    end

    if @end_date.present?
      @balance_sheets = @balance_sheets.where("recorded_at <= ?", Date.parse(@end_date).end_of_day)
    end

    @accounts = current_user.accounts.order(:name)
    @total_net_worth = @balance_sheets.sum(:net_worth)
    @average_net_worth = @balance_sheets.count > 0 ? @total_net_worth / @balance_sheets.count : 0
  end
end
