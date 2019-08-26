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
      @employee.send_activation_email
      flash[:info] = "Please check your email to activate your account. "
      redirect_to root_url
    else
      render 'new'
    end
  end

  def index
    @employees = Employee.where(activated: true).paginate(page: params[:page], per_page: 20)
  end

  def show
    @employee = Employee.find(params[:id])
    @teams = @employee.teams
    redirect_to root_url and return unless @employee.activated?
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
    @employees = Employee.where(activated: true).search(params[:search]).paginate(page: params[:page], per_page: 20)
  end

  def tagged
    if params[:tag].present?
      @employees = Employee.tagged_with(params[:tag]).paginate(page: params[:page], per_page: 20)
    else
      all
    end
  end


  private

    def employee_params
      params.require(:employee).permit(:name, :email, :photo, :team_ids, :position, :employed_at, :password, :password_confirmation, :tag_list)
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
