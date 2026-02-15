class LiabilitiesController < ApplicationController
  def show
    @liability = Liability.joins(:balance_sheet).find_by(id: params[:id], balance_sheets: { user_id: current_user.id })
    if @liability.nil?
      redirect_to balance_sheets_path, alert: "Pasivo no encontrado."
      return
    end
    @balance_sheet = @liability.balance_sheet

    # Find all liabilities with the same name within the same account for the current user
    # ordered by the balance sheet's recorded_at date
    @liability_history = Liability.joins(:balance_sheet)
                          .where(balance_sheets: {
                            user_id: current_user.id,
                            account_id: @balance_sheet.account_id
                          })
                          .where(name: @liability.name)
                          .order("balance_sheets.recorded_at ASC")
                          .pluck("balance_sheets.recorded_at", :amount)

    # Prepare data for Chart.js
    @chart_data = {
      labels: @liability_history.map { |date, _| date.strftime("%Y-%m-%d") },
      datasets: [ {
        label: "Valor de #{@liability.name}",
        data: @liability_history.map { |_, amount| amount.to_f },
        borderColor: "#ef4444",
        backgroundColor: "rgba(239, 68, 68, 0.2)",
        fill: true
      } ]
    }
  end
end
