class SessionsController < ApplicationController
  def new
  end

  def create
    employee = Employee.find_by(email: params[:session][:email].downcase)
    if employee && employee.authenticate(params[:session][:password])
      if employee.activated?
        log_in employee
        params[:session][:remember_me] == '1' ? remember(employee):forget(employee)
        redirect_to employee
      else
        message = "Account not activated. "
        message += "Check your email for the activation link. "
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = "You have logged out successfully. "
    redirect_to root_url
  end
end
