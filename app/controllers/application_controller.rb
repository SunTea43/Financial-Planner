class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :authenticate_user!, unless: :devise_controller_or_home?
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def devise_controller_or_home?
    devise_controller? || controller_name == "home"
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :preferred_currency ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :preferred_currency ])
  end
end
