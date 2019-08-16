require 'test_helper'

class EmployeesSignupTest < ActionDispatch::IntegrationTest

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

  test "valid signup information" do
    get signup_path
    assert_difference 'Employee.count', 1 do
      post employees_path, params: { employee: { name: "Example User",
                                    email: "user@wamazing.jp",
                                    password: "password",
                                    password_confirmation: "password"} }
    end
    follow_redirect!
    assert_template 'employees/show'
    assert_not flash.empty?
  end

end
