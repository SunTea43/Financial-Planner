require "test_helper"

class SavingsPlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
    @savings_plan = savings_plans(:one)
  end

  test "should get index" do
    get savings_plans_url
    assert_response :success
  end

  test "should create savings plan" do
    assert_difference("SavingsPlan.count", 1) do
      post savings_plans_url, params: {
        savings_plan: {
          name: "Meta de vivienda",
          goal_amount: 250000,
          start_date: Date.current,
          target_date: Date.current.advance(years: 2),
          annual_interest_rate: 10
        }
      }
    end

    assert_redirected_to savings_plan_url(SavingsPlan.last)
  end

  test "should show savings plan" do
    @savings_plan.update!(initial_capital: 20000)
    @user.update!(preferred_currency: "COP")

    get savings_plan_url(@savings_plan)
    assert_response :success
    assert_includes response.body, I18n.t("views.savings_plans.show.initial_capital")
    assert_match(/\$\s?20[\.,]000/, response.body)
    assert_includes response.body, I18n.t("views.savings_plans.show.annual_outlay_detail")
  end

  test "should hide initial capital in show when value is zero" do
    @savings_plan.update!(initial_capital: 0)

    get savings_plan_url(@savings_plan)
    assert_response :success
    assert_not_includes response.body, I18n.t("views.savings_plans.show.initial_capital")
  end

  test "should update savings plan" do
    patch savings_plan_url(@savings_plan), params: {
      savings_plan: {
        name: "Fondo actualizado"
      }
    }

    assert_redirected_to savings_plan_url(@savings_plan)
    assert_equal "Fondo actualizado", @savings_plan.reload.name
  end

  test "should destroy savings plan" do
    assert_difference("SavingsPlan.count", -1) do
      delete savings_plan_url(@savings_plan)
    end

    assert_redirected_to savings_plans_url
  end
end
