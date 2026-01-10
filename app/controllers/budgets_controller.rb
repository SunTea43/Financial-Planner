class BudgetsController < ApplicationController
  before_action :set_budget, only: [:show, :edit, :update, :destroy]
  before_action :set_account, only: [:new, :create]

  def index
    @budgets = current_user.budgets.includes(:account, :budget_items)
                           .order(start_date: :desc)
  end

  def show
  end

  def new
    @budget = current_user.budgets.build(account: @account)
    @budget.periodicity = 'monthly'
    @budget.start_date = Date.current.beginning_of_month
    @budget.end_date = Date.current.end_of_month
    @budget.budget_items.build(item_type: 'income')
    @budget.budget_items.build(item_type: 'expense')
  end

  def create
    @budget = current_user.budgets.build(budget_params)

    if @budget.save
      redirect_to @budget, notice: 'Presupuesto creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @budget.budget_items.build(item_type: 'income') if @budget.budget_items.select { |item| item.item_type == 'income' }.empty?
    @budget.budget_items.build(item_type: 'expense') if @budget.budget_items.select { |item| item.item_type == 'expense' }.empty?
  end

  def update
    if @budget.update(budget_params)
      redirect_to @budget, notice: 'Presupuesto actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @budget.destroy
    redirect_to budgets_path, notice: 'Presupuesto eliminado exitosamente.'
  end

  private

  def set_budget
    @budget = current_user.budgets.find(params[:id])
  end

  def set_account
    @account = current_user.accounts.find(params[:account_id]) if params[:account_id].present?
  end

  def budget_params
    params.require(:budget).permit(:account_id, :name, :periodicity, :start_date, :end_date,
      budget_items_attributes: [:id, :name, :item_type, :amount, :description, :_destroy])
  end
end
