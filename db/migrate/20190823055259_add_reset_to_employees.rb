class AddResetToEmployees < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :reset_digest, :string
    add_column :employees, :reset_sent_at, :datetime
  end
end
