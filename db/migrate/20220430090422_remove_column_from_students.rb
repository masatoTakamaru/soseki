class RemoveColumnFromStudents < ActiveRecord::Migration[6.1]
  def change
    remove_column :students, :postal_code
    remove_column :students, :address
    remove_column :students, :user_name
    remove_column :students, :password_digest

  end
end
