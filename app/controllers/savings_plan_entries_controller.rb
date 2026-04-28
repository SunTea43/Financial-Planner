class SavingsPlanEntriesController < ApplicationController
  before_action :set_savings_plan
  before_action :set_entry, only: [ :edit, :update, :destroy ]

  def index
    @entries = @savings_plan.entries.by_date
  end

  def new
    @entry = @savings_plan.entries.build(entry_date: Date.current)
  end

  def create
    @entry = @savings_plan.entries.build(entry_params)

    if @entry.save
      redirect_to savings_plan_path(@savings_plan), notice: I18n.t("controllers.savings_plan_entries.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @entry.update(entry_params)
      redirect_to savings_plan_path(@savings_plan), notice: I18n.t("controllers.savings_plan_entries.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @entry.destroy
    redirect_to savings_plan_path(@savings_plan), notice: I18n.t("controllers.savings_plan_entries.deleted")
  end

  private

  def set_savings_plan
    @savings_plan = current_user.savings_plans.find(params[:savings_plan_id])
  end

  def set_entry
    @entry = @savings_plan.entries.find(params[:id])
  end

  def entry_params
    params.require(:savings_plan_entry).permit(:entry_date, :amount, :frequency, :notes)
  end
end
