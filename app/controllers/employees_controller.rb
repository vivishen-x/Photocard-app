class EmployeesController < ApplicationController
  before_action :logged_in_employee, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_employee, only: [:edit, :update]
  before_action :admin_employee, only: :destroy

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

  def index
    @employees = Employee.paginate(page: params[:page], per_page: 10)
  end

  def show
    @employee = Employee.find(params[:id])
    @teams = @employee.teams
  end

  def edit
    @employee = Employee.find(params[:id])
    @team_employee = @employee.team_employees
  end

  def update
    @employee = Employee.find(params[:id])
    if @employee.update_attributes(employee_params)
      flash[:success] = "Profile updated"
      redirect_to @employee
    else
      render 'edit'
    end
  end

  def destroy
    Employee.find(params[:id]).destroy
    flash[:success] = "Delete successfully"
    redirect_to employees_path
  end

  def search
    @employees = Employee.search(params[:search]).paginate(page: params[:page])
  end



  private

    def employee_params
      params.require(:employee).permit(:name, :email, :photo, :team_ids, :position, :employed_at, :password, :password_confirmation)
    end

    def logged_in_employee
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def correct_employee
      @employee = Employee.find(params[:id])
      redirect_to(root_url) unless current_employee?(@employee)
    end

    def admin_employee
      redirect_to(root_url) unless current_employee.admin?
    end
end
