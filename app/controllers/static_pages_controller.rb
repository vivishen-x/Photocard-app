class StaticPagesController < ApplicationController
  def home
    @employees = Employee.all
  end
end
