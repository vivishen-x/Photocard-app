class ChangePhotoDefaultValueToEmployees < ActiveRecord::Migration[5.1]
  def change
    change_column_default :employees, :photo, ''
  end
end
