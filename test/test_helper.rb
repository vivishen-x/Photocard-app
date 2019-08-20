ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def is_logged_in?
    !session[:employee_id].nil?
  end

  def log_in_as(employee)
    session[:employee_id] = employee.id
  end
end

class ActionDispatch::IntegrationTest
  def log_in_as(employee, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: employee.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end
