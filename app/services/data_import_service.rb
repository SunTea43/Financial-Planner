class DataImportService
  def initialize(user, data)
    @user = user
    @data = data
    @account_id_map = {} # Maps old account IDs to new account IDs
  end

  def call
    ActiveRecord::Base.transaction do
      import_user_settings
      import_accounts
      import_balance_sheets
      import_budgets
      import_savings_plans
    end
  end

  private

  def import_user_settings
    settings = @data["user_settings"] || {}
    preferred_currency = settings["preferred_currency"]
    return if preferred_currency.blank?

    @user.update!(preferred_currency: preferred_currency)
  end

  def import_accounts
    return unless @data["accounts"]

    @data["accounts"].each do |account_attrs|
      old_id = account_attrs["id"]
      new_account = @user.accounts.create!(
        name: account_attrs["name"],
        account_type: account_attrs["account_type"],
        description: account_attrs["description"],
        created_at: account_attrs["created_at"],
        updated_at: account_attrs["updated_at"]
      )
      @account_id_map[old_id] = new_account.id
    end
  end

  def import_balance_sheets
    return unless @data["balance_sheets"]

    @data["balance_sheets"].each do |bs_attrs|
      new_account_id = @account_id_map[bs_attrs["account_id"]] if bs_attrs["account_id"]

      assets_data = bs_attrs.delete("assets") || []
      liabilities_data = bs_attrs.delete("liabilities") || []

      new_bs = @user.balance_sheets.create!(
        account_id: new_account_id,
        recorded_at: bs_attrs["recorded_at"],
        total_assets: bs_attrs["total_assets"],
        total_liabilities: bs_attrs["total_liabilities"],
        net_worth: bs_attrs["net_worth"],
        notes: bs_attrs["notes"],
        created_at: bs_attrs["created_at"],
        updated_at: bs_attrs["updated_at"]
      )

      assets_data.each do |asset_attrs|
        new_bs.assets.create!(
          name: asset_attrs["name"],
          item_type: asset_attrs["item_type"],
          category: asset_attrs["category"],
          amount: asset_attrs["amount"],
          description: asset_attrs["description"],
          position: asset_attrs["position"],
          created_at: asset_attrs["created_at"],
          updated_at: asset_attrs["updated_at"]
        )
      end

      liabilities_data.each do |liability_attrs|
        new_bs.liabilities.create!(
          name: liability_attrs["name"],
          item_type: liability_attrs["item_type"],
          category: liability_attrs["category"],
          amount: liability_attrs["amount"],
          description: liability_attrs["description"],
          position: liability_attrs["position"],
          created_at: liability_attrs["created_at"],
          updated_at: liability_attrs["updated_at"]
        )
      end

      new_bs.save!
    end
  end

  def import_budgets
    return unless @data["budgets"]

    @data["budgets"].each do |budget_attrs|
      new_account_id = @account_id_map[budget_attrs["account_id"]] if budget_attrs["account_id"]

      items_data = budget_attrs.delete("budget_items") || []

      new_budget = @user.budgets.create!(
        account_id: new_account_id,
        name: budget_attrs["name"],
        periodicity: budget_attrs["periodicity"],
        start_date: budget_attrs["start_date"],
        end_date: budget_attrs["end_date"],
        total_income: budget_attrs["total_income"],
        total_expenses: budget_attrs["total_expenses"],
        free_cash_flow: budget_attrs["free_cash_flow"],
        created_at: budget_attrs["created_at"],
        updated_at: budget_attrs["updated_at"]
      )

      items_data.each do |item_attrs|
        new_budget.budget_items.create!(
          name: item_attrs["name"],
          item_type: item_attrs["item_type"],
          amount: item_attrs["amount"],
          description: item_attrs["description"],
          position: item_attrs["position"],
          created_at: item_attrs["created_at"],
          updated_at: item_attrs["updated_at"]
        )
      end

      new_budget.save!
    end
  end

  def import_savings_plans
    return unless @data["savings_plans"]

    @data["savings_plans"].each do |plan_attrs|
      @user.savings_plans.create!(
        name: plan_attrs["name"],
        goal_amount: plan_attrs["goal_amount"],
        initial_capital: plan_attrs["initial_capital"] || 0,
        start_date: plan_attrs["start_date"],
        target_date: plan_attrs["target_date"],
        annual_interest_rate: plan_attrs["annual_interest_rate"],
        created_at: plan_attrs["created_at"],
        updated_at: plan_attrs["updated_at"]
      )
    end
  end
end
