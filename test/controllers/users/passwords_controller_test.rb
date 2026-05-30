require "test_helper"

class Users::PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "password reset page signs out current user to avoid bypass" do
    post user_session_path, params: {
      user: {
        email: @user.email,
        password: "password123",
        remember_me: "1"
      }
    }

    raw_token, encrypted_token = Devise.token_generator.generate(User, :reset_password_token)
    @user.update!(reset_password_token: encrypted_token, reset_password_sent_at: Time.current)

    get edit_user_password_path(reset_password_token: raw_token)
    assert_response :success

    get dashboard_index_path
    assert_redirected_to new_user_session_path
  end

  test "login form supports browser autofill and password visibility toggle" do
    get new_user_session_path
    assert_response :success

    assert_select "input[name='user[email]'][autocomplete='username']"
    assert_select "input[name='user[password]'][autocomplete='current-password']"
    assert_select "[data-controller='password-visibility']"
    assert_select "button[data-action='click->password-visibility#toggle']", count: 1
  end
end
