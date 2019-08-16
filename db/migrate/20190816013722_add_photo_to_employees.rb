class AddPhotoToEmployees < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :photo, :string, default: 'default.png'
  end
end
