module Users
  class PasswordsController < Devise::PasswordsController
    before_action :sign_out_current_user_for_password_reset, only: %i[ edit update ]

    private

    def sign_out_current_user_for_password_reset
      return unless params[:reset_password_token].present?
      return unless user_signed_in?

      sign_out(resource_name)
    end
  end
end
