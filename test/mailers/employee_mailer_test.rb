require 'test_helper'

class EmployeeMailerTest < ActionMailer::TestCase
  test "account_activation" do
    employee = employees(:michael)
    employee.activation_token = Employee.new_token
    mail = EmployeeMailer.account_activation(employee)
    assert_equal "Account activation", mail.subject
    assert_equal [employee.email], mail.to
    assert_equal ["noreply@wamazing.jp"], mail.from
    assert_match employee.name, mail.body.encoded
    assert_match employee.activation_token, mail.body.encoded
    assert_match CGI.escape(employee.email), mail.body.encoded
  end

  test "password_reset" do
    employee = employees(:michael)
    employee.reset_token = Employee.new_token
    mail = EmployeeMailer.password_reset(employee)
    assert_equal "Password reset", mail.subject
    assert_equal [employee.email], mail.to
    assert_equal ["noreply@wamazing.jp"], mail.from
    assert_match employee.reset_token, mail.body.encoded
    assert_match CGI.escape(employee.email), mail.body.encoded
  end

end
