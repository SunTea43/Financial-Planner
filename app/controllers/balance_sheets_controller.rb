class BalanceSheetsController < ApplicationController
  before_action :set_balance_sheet, only: [ :show, :edit, :update, :destroy, :report, :duplicate ]
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
    set_account_from_params
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
    set_account_from_params
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

  def duplicate
    @new_balance_sheet = current_user.balance_sheets.build(
      account_id: @balance_sheet.account_id,
      recorded_at: Time.current,
      notes: @balance_sheet.notes
    )

    # Construir activos duplicados
    @balance_sheet.assets.each do |asset|
      @new_balance_sheet.assets.build(
        name: asset.name,
        asset_type: asset.asset_type,
        category: asset.category,
        amount: asset.amount,
        description: asset.description
      )
    end

    # Construir pasivos duplicados
    @balance_sheet.liabilities.each do |liability|
      @new_balance_sheet.liabilities.build(
        name: liability.name,
        liability_type: liability.liability_type,
        amount: liability.amount,
        description: liability.description
      )
    end

    if @new_balance_sheet.save
      redirect_to edit_balance_sheet_path(@new_balance_sheet), notice: "Balance general duplicado exitosamente. Puedes editarlo ahora."
    else
      redirect_to @balance_sheet, alert: "Error al duplicar el balance general: #{@new_balance_sheet.errors.full_messages.join(', ')}"
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
    params.require(:balance_sheet).permit(:notes,
      assets_attributes: [ :id, :name, :asset_type, :category, :amount, :description, :position, :_destroy ],
      liabilities_attributes: [ :id, :name, :liability_type, :amount, :description, :position, :_destroy ])
  end

  def parse_recorded_at
    return nil unless params[:balance_sheet] && params[:balance_sheet][:recorded_at].present?
    Time.zone.parse(params[:balance_sheet][:recorded_at])
  rescue ArgumentError, TypeError
    nil
  end

  def set_account_from_params
    if params[:balance_sheet][:account_id].present?
      @balance_sheet.account = current_user.accounts.find_by(id: params[:balance_sheet][:account_id])
    end
  end
end
