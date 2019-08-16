class EmployeesController < ApplicationController
  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      log_in @employee
      flash[:success] = "Welcome to our service! Fill in more information about you! "
      redirect_to @employee
    else
      render 'new'
    end
  end

  def show
    @employee = Employee.find(params[:id])
  end

  def edit
  end

  private

    def employee_params
      params.require(:employee).permit(:name, :email, :password, :password_confirmation)
    end
end
