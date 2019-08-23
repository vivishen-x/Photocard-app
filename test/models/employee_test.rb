require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase

  def setup
    @employee = Employee.new(name:"Example Employee", email:"example@wamazing.jp",
                             password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @employee.valid?
  end

  test "name should be present" do
    @employee.name = "   "
    assert_not @employee.valid?
  end

  test "email should be present" do
    @employee.email = "   "
    assert_not @employee.valid?
  end

  test "name should not be too long" do
    @employee.name = "a" * 51
    assert_not @employee.valid?
  end

  test "email should not be too long" do
    @employee.email = "a" * 244 + "@wamazing.jp"
    assert_not @employee.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@wamazing.jp USER@wamazing.jp A_US-ER@wamazing.jp
                         first.last@wamazing.jp alice+bob@wamazing.jp]
    valid_addresses.each do |valid_address|
      @employee.email = valid_address
      assert @employee.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@gmail.com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @employee.email = invalid_address
      assert_not @employee.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @employee.dup
    duplicate_user.email = @employee.email.upcase
    @employee.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@WAmazing.JP"
    @employee.email = mixed_case_email
    @employee.save
    assert_equal mixed_case_email.downcase, @employee.reload.email
  end

  test "password should be present (nonblank)" do
    @employee.password = @employee.password_confirmation = " " * 8
    assert_not @employee.valid?
  end

  test "password should have a minimum length" do
    @employee.password = @employee.password_confirmation = "a" * 7
    assert_not @employee.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @employee.authenticated?(:remember,'')
  end

end
