require 'test_helper'

class EmployeesEditTest < ActionDispatch::IntegrationTest

  def setup
    @employee = employees(:michael)

  end

  test "unsuccessful edit" do
    log_in_as(@employee)
    get edit_employee_path(@employee)
    assert_template 'employees/edit'
    patch employee_path(@employee), params: { employee: { name: "",
                                              email: "user@invalid.com",
                                              password: "foo",
                                              password_confirmation: "foo"} }
    assert_template 'employees/edit'
  end

  test "successful edit" do
    log_in_as(@employee)
    get edit_employee_path(@employee)
    assert_template 'employees/edit'
    name = "Foo Bar"
    position = "Project Manager"
    employed_at = 1.year.ago
    patch employee_path(@employee), params: { employee: { name: name,
                                              position: position,
                                              employed_at: employed_at,
                                              password: "",
                                              password_confirmation: ""} }
    assert_not flash.empty?
    assert_redirected_to @employee
    @employee.reload
    assert_equal name, @employee.name
    assert_equal position, @employee.position
    assert_in_delta employed_at, @employee.employed_at, 1.second
  end
end
