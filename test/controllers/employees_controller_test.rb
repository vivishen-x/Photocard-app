require 'test_helper'

class EmployeesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @employee = employees(:michael)
    @other_employee = employees(:archer)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect update when not logged in" do
    patch employee_path(@employee), params: { employee: { name: @employee.name,
                                              email: @employee.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_employee)
    assert_not @other_employee.admin?
    patch employee_path(@other_employee), params: { employee: { password: "password",
                                                                password_confirmation: "password" } }
    assert_not @other_employee.reload.admin?
  end

  test "should redirect destoy when not logged in" do
    assert_no_difference 'Employee.count' do
      delete employee_path(@employee)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as non-admin" do
    log_in_as(@other_employee)
    assert_no_difference 'Employee.count' do
      delete employee_path(@employee)
    end
    assert_redirected_to root_url
  end

end
