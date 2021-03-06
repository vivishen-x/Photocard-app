class TeamEmployee < ApplicationRecord
  belongs_to :employee
  belongs_to :team

  validates :employee, presence: true
  validates :team, presence: true

  # default_scope -> { includes(:employee).order("employees.name") }
end
