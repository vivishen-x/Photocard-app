class PasswordResetsController < ApplicationController
  before_action :get_employee, only: [:edit, :update]
  before_action :valid_employee, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]


  def new
  end

  def create
    @employee = Employee.find_by(email: params[:password_reset][:email].downcase)
    if @employee
      @employee.create_reset_digest
      @employee.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:employee][:password].empty?
      @employee.errors.add(:password, :blank)
      render 'edit'
    elsif @employee.update_attributes(employee_params)
      log_in @employee
      @employee.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset. "
      redirect_to @employee
    else
      render 'edit'
    end

  end

  private
    def employee_params
      params.require(:employee).permit(:password, :password_confirmation)
    end


    def get_employee
      @employee = Employee.find_by(email: params[:email])
    end

    def valid_employee
      unless (@employee && @employee.activated? &&
          @employee.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    def check_expiration
      if @employee.password_reset_expired?
        flash[:danger] = "Password reset has expired. "
        redirect_to new_password_reset_path
      end
    end

end
