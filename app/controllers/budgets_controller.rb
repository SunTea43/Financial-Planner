class BudgetsController < ApplicationController
  before_action :set_budget, only: [ :show, :edit, :update, :destroy ]
  before_action :set_account, only: [ :new, :create ]
  before_action :load_budget_categories, only: [ :new, :edit, :create, :update ]

  def index
    @budgets = current_user.budgets.includes(:account, :budget_items)
                           .order(start_date: :desc)
  end

  def show
    @expense_category_chart_data = prepare_category_chart_data(item_type: "expense")
    @income_category_chart_data = prepare_category_chart_data(item_type: "income")
    @budget_indicators = {
      savings_ratio: @budget.savings_ratio,
      investment_ratio: @budget.investment_ratio,
      expense_ratio: @budget.expense_ratio,
      essential_expense_ratio: @budget.essential_expense_ratio,
      debt_service_ratio: @budget.debt_service_ratio,
      discretionary_expense_ratio: @budget.discretionary_expense_ratio
    }
  end

  def new
    if params[:clone_id].present? && (original_budget = current_user.budgets.find_by(id: params[:clone_id]))
      @budget = original_budget.build_clone_for_next_period
      @budget.account = @account if @account.present?
    else
      @budget = current_user.budgets.build(account: @account)
      @budget.periodicity = "monthly"
      @budget.start_date = Date.current.beginning_of_month
      @budget.end_date = Date.current.end_of_month
      @budget.budget_items.build(item_type: "income")
      @budget.budget_items.build(item_type: "expense")
    end
  end

  def create
    @budget = current_user.budgets.build(budget_params)
    set_account_from_params

    if @budget.save
      redirect_to @budget, notice: I18n.t("controllers.budgets.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @budget.budget_items.build(item_type: "income") if @budget.budget_items.select { |item| item.item_type == "income" }.empty?
    @budget.budget_items.build(item_type: "expense") if @budget.budget_items.select { |item| item.item_type == "expense" }.empty?
  end

  def update
    @budget.assign_attributes(budget_params)
    set_account_from_params
    if @budget.save
      redirect_to @budget, notice: I18n.t("controllers.budgets.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @budget.destroy
    redirect_to budgets_path, notice: I18n.t("controllers.budgets.deleted")
  end

  private

  def set_budget
    @budget = current_user.budgets.find(params[:id])
  end

  def set_account
    @account = current_user.accounts.find(params[:account_id]) if params[:account_id].present?
  end

  def budget_params
    params.require(:budget).permit(:name, :periodicity, :start_date, :end_date,
      budget_items_attributes: [ :id, :name, :item_type, :amount, :category, :description, :position, :_destroy ])
  end

  def set_account_from_params
    if params[:budget][:account_id].present?
      @budget.account = current_user.accounts.find_by(id: params[:budget][:account_id])
    end
  end

  def load_budget_categories
    @budget_categories = BudgetItem.unscoped
                                   .joins(:budget)
                                   .where(budgets: { user_id: current_user.id })
                                   .where.not(category: [ nil, "" ])
                                   .distinct
                                   .pluck(:category)
                                   .sort_by(&:downcase)
  end

  def prepare_category_chart_data(item_type:)
    grouped_items = @budget.budget_items
                         .select { |item| item.item_type == item_type }
                         .group_by { |item| item.category.presence || I18n.t("views.budgets.show.uncategorized") }

    {
      labels: grouped_items.keys,
      values: grouped_items.values.map { |items| items.sum { |item| item.amount.to_f } }
    }
  end
end
