module ApplicationHelper
  def number_to_currency(number, options = {})
    currency_account = options.delete(:account) || resolved_currency_account
    configured_options = currency_options(currency_account)
    return super(number, options) if configured_options.empty?

    super(number, configured_options.merge(options))
  end

  def current_currency_code
    resolved_currency_account&.preferred_currency || Account::DEFAULT_CURRENCY
  end

  private

  def currency_options(account)
    return {} unless account&.respond_to?(:currency_format_options)

    account.currency_format_options
  end

  def resolved_currency_account
    return @resolved_currency_account if defined?(@resolved_currency_account)

    @resolved_currency_account = account_from_instance_variables || account_from_params || fallback_account
  end

  def account_from_instance_variables
    records = [
      instance_variable_get(:@account),
      instance_variable_get(:@balance_sheet),
      instance_variable_get(:@budget),
      instance_variable_get(:@new_balance_sheet),
      instance_variable_get(:@new_budget),
      instance_variable_get(:@savings_plan),
      instance_variable_get(:@entry)
    ]

    records.each do |record|
      return record if record.is_a?(Account)
      return record.account if record&.respond_to?(:account) && record.account.present?
    end

    nil
  end

  def account_from_params
    return nil unless respond_to?(:params, true)
    return nil unless respond_to?(:current_user, true)

    account_id = params[:account_id] ||
                 params.dig(:balance_sheet, :account_id) ||
                 params.dig(:budget, :account_id)
    return nil if account_id.blank?

    current_user&.accounts&.find_by(id: account_id)
  end

  def fallback_account
    return nil unless respond_to?(:current_user, true)

    current_user&.accounts&.order(:created_at)&.first
  end
end
