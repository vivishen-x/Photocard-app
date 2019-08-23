require 'test_helper'

class EmployeesIndexTest < ActionDispatch::IntegrationTest

    def setup
      @admin = employees(:michael)
      @non_admin = employees(:archer)
    end

    test "index as admin including pagination and delete links" do
      log_in_as(@admin)
      get employees_path
      assert_template 'employees/index'
      assert_select 'div.pagination', count: 2
      first_page_of_employees = Employee.paginate(page: 1, per_page: 5)
      first_page_of_employees.each do |employee|

        assert_select 'a[href=?]', employee_path(employee)
        assert_select 'h2', employee.name
      end

      get employee_path(@non_admin)
      assert_difference 'Employee.count', -1 do
        delete employee_path(@non_admin)
      end
    end

    test "index as non-admin" do
      log_in_as(@non_admin)
      get employee_path(@admin)
      assert_select 'a', text: 'Delete Account', count: 0
    end

end
