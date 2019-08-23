require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @employee = employees(:michael)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # invalid email
    post password_resets_path, params: { password_reset: { email: " " } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # valid email
    post password_resets_path,
      params: { password_reset: { email: @employee.email } }
    assert_not_equal @employee.reset_digest, @employee.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # password reset
    employee = assigns(:employee)
    # invalid email
    get edit_password_reset_path(employee.reset_token, email: "")
    assert_redirected_to root_url
    # invalid user
    employee.toggle!(:activated)
    get edit_password_reset_path(employee.reset_token, email: employee.email)
    assert_redirected_to root_url
    employee.toggle!(:activated)
    # valid email, invalid token
    get edit_password_reset_path('wrong token', email: employee.email)
    assert_redirected_to root_url
    # valid email, valid token
    get edit_password_reset_path(employee.reset_token, email: employee.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", employee.email
    # invalid pwd
    patch password_reset_path(employee.reset_token),
        params: { email: employee.email,
                  employee: { password: "fofofo",
                              password_confirmation: "bababa" } }
    assert_select 'div#error_explanation'
    #empty pwd
    patch password_reset_path(employee.reset_token),
        params: { email: employee.email,
                  employee: { password: "",
                              password_confirmation: "" } }
    assert_select 'div#error_explanation'
    # valid pwd
    patch password_reset_path(employee.reset_token),
        params: { email: employee.email,
                  employee: { password: "validpass",
                              password_confirmation: "validpass" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to employee
  end


  test "expired token" do
    get new_password_reset_path
    post password_resets_path,
      params: { password_reset: { email: @employee.email } }

    @employee = assigns(:employee)
    @employee.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@employee.reset_token),
      params: { email: @employee.email,
          employee: { password: "foofoobar",
                      password_confirmation: "foofoobar" } }
    assert_response :redirect
    follow_redirect!
    assert_match "Password reset has expired. ", response.body
  end

end
