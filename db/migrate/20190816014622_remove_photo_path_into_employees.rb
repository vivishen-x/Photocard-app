class RemovePhotoPathIntoEmployees < ActiveRecord::Migration[5.1]
  def change
    remove_column :employees, :photo_path
  end
end
