class CreateTeamEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table :team_employees do |t|
      t.references :employee, index: true, foreign_key: true
      t.references :team, index: true, foreign_key: true

      t.timestamps
    end
  end
end
