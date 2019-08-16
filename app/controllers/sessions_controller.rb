class SessionsController < ApplicationController
  def new
  end

  def create
    employee = Employee.find_by(email: params[:session][:email].downcase)
    if employee && employee.authenticate(params[:session][:password])
      #login
      log_in employee
      redirect_to employee
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    flash[:success] = "You have logged out successfully. "
    redirect_to root_url
  end
end
