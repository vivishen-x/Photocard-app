class Team < ApplicationRecord
  has_many :team_employees
  has_many :employees, through: :team_employees
  accepts_nested_attributes_for :team_employees
end
