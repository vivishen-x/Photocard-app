module SessionsHelper
  def log_in(employee)
    session[:employee_id] = employee.id
  end

  def remember(employee)
    employee.remember
    cookies.permanent.signed[:employee_id] = employee.id
    cookies.permanent[:remember_token] = employee.remember_token
  end

  def current_employee?(user)
    user == current_employee
  end

  def current_employee
    if (employee_id = session[:employee_id])
      @current_employee ||= Employee.find_by(id: session[:employee_id])
    elsif (employee_id = cookies.signed[:employee_id])
      employee = Employee.find_by(id: employee_id)
      if employee && employee.authenticated?(:remember, cookies[:remember_token])
        log_in employee
        @current_employee = employee
      end
    end
  end

  def logged_in?
    !current_employee.nil?
  end

  def forget(employee)
    employee.forget
    cookies.delete(:employee_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_employee)
    session.delete(:employee_id)
    @current_employee = nil
  end
end
