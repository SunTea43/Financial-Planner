class BalanceSheetsController < ApplicationController
  before_action :set_balance_sheet, only: [ :show, :edit, :update, :destroy, :report ]
  before_action :set_account, only: [ :new, :create ]

  def index
    @balance_sheets = current_user.balance_sheets.includes(:account, :assets, :liabilities)
                                   .latest
  end

  def show
  end

  def new
    @balance_sheet = current_user.balance_sheets.build
    @balance_sheet.account = @account if @account
    @balance_sheet.recorded_at = Time.current
    @balance_sheet.assets.build if @balance_sheet.assets.empty?
    @balance_sheet.liabilities.build if @balance_sheet.liabilities.empty?
  end

  def create
    @balance_sheet = current_user.balance_sheets.build(balance_sheet_params)
    @balance_sheet.recorded_at = parse_recorded_at || Time.current

    if @balance_sheet.save
      redirect_to @balance_sheet, notice: "Balance general creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @balance_sheet.assets.build if @balance_sheet.assets.empty?
    @balance_sheet.liabilities.build if @balance_sheet.liabilities.empty?
  end

  def update
    @balance_sheet.assign_attributes(balance_sheet_params)
    parsed_time = parse_recorded_at
    @balance_sheet.recorded_at = parsed_time if parsed_time
    if @balance_sheet.save
      redirect_to @balance_sheet, notice: "Balance general actualizado exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @balance_sheet.destroy
    redirect_to balance_sheets_path, notice: "Balance general eliminado exitosamente."
  end

  def report
    respond_to do |format|
      format.html
      format.pdf do
        # PDF generation could be added here with prawn or wicked_pdf
        redirect_to @balance_sheet, notice: "Reporte PDF en desarrollo."
      end
    end
  end

  private

  def set_balance_sheet
    @balance_sheet = current_user.balance_sheets.find(params[:id])
  end

  def set_account
    @account = current_user.accounts.find(params[:account_id]) if params[:account_id].present?
  end

  def balance_sheet_params
    params.require(:balance_sheet).permit(:account_id, :notes,
      assets_attributes: [ :id, :name, :asset_type, :category, :amount, :description, :_destroy ],
      liabilities_attributes: [ :id, :name, :liability_type, :amount, :description, :_destroy ])
  end

  def parse_recorded_at
    return nil unless params[:balance_sheet] && params[:balance_sheet][:recorded_at].present?
    Time.zone.parse(params[:balance_sheet][:recorded_at])
  rescue ArgumentError, TypeError
    nil
  end
end
