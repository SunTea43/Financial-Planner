class AssetsController < ApplicationController
  def show
    @asset = Asset.joins(:balance_sheet).find_by(id: params[:id], balance_sheets: { user_id: current_user.id })
    if @asset.nil?
      redirect_to balance_sheets_path, alert: "Activo no encontrado."
      return
    end
    @balance_sheet = @asset.balance_sheet

    # Find all assets with the same name within the same account for the current user
    # ordered by the balance sheet's recorded_at date
    @asset_history = Asset.joins(:balance_sheet)
                          .where(balance_sheets: {
                            user_id: current_user.id,
                            account_id: @balance_sheet.account_id
                          })
                          .where(name: @asset.name)
                          .reorder("balance_sheets.recorded_at ASC")
                          .pluck("balance_sheets.recorded_at", :amount)

    # Prepare data for Chart.js
    @chart_data = {
      labels: @asset_history.map { |date, _| date.strftime("%Y-%m-%d") },
      datasets: [ {
        label: "Valor de #{@asset.name}",
        data: @asset_history.map { |_, amount| amount.to_f },
        borderColor: "#3b82f6",
        backgroundColor: "rgba(59, 130, 246, 0.2)",
        fill: true
      } ]
    }
  end
end
