module ApplicationHelper
  def number_to_currency(number, options = {})
    configured_options = currency_options
    return super(number, options) if configured_options.empty?

    super(number, configured_options.merge(options))
  end

  def current_currency_code
    current_user&.preferred_currency || User::DEFAULT_CURRENCY
  end

  private

  def currency_options
    return {} unless respond_to?(:current_user, true)

    user = current_user
    return {} unless user&.respond_to?(:currency_format_options)

    user.currency_format_options
  end
end
