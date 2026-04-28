class SavingsPlansController < ApplicationController
  before_action :set_savings_plan, only: [ :show, :edit, :update, :destroy ]

  def index
    @savings_plans = current_user.savings_plans.recent
  end

  def show
    @projection = @savings_plan.projection
  end

  def new
    @savings_plan = current_user.savings_plans.build(
      start_date: Date.current,
      target_date: Date.current.advance(years: 1),
      annual_interest_rate: 8.0
    )
  end

  def create
    @savings_plan = current_user.savings_plans.build(savings_plan_params)

    if @savings_plan.save
      redirect_to @savings_plan, notice: I18n.t("controllers.savings_plans.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @savings_plan.update(savings_plan_params)
      redirect_to @savings_plan, notice: I18n.t("controllers.savings_plans.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @savings_plan.destroy
    redirect_to savings_plans_path, notice: I18n.t("controllers.savings_plans.deleted")
  end

  private

  def set_savings_plan
    @savings_plan = current_user.savings_plans.find(params[:id])
  end

  def savings_plan_params
    params.require(:savings_plan).permit(:name, :goal_amount, :start_date, :target_date, :annual_interest_rate)
  end
end
