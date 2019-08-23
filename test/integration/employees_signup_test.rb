require 'test_helper'

class EmployeesSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'Employee.count' do
      post employees_path, params: { employee: { name: "",
                                    email: "user@invalid",
                                    password: "password",
                                    password_confirmation: "password"} }
    end
    assert_template 'employees/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'form[action="/signup"]'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'Employee.count', 1 do
      post employees_path, params: { employee: { name: "Example User",
                                    email: "user@wamazing.jp",
                                    password: "password",
                                    password_confirmation: "password"} }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    employee = assigns(:employee)
    assert_not employee.activated?

    log_in_as(employee)
    assert_not is_logged_in?
    get edit_account_activation_path("invalid token", email: employee.email)
    assert_not is_logged_in?
    get edit_account_activation_path(employee.activation_token, email: 'wrong')
    assert_not is_logged_in?
    get edit_account_activation_path(employee.activation_token, email: employee.email)
    assert employee.reload.activated?
    follow_redirect!
    
    assert_template 'employees/show'
    assert is_logged_in?
    assert_not flash.empty?
  end

end
