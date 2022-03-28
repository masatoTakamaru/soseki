class ChangeColumnToStudent < ActiveRecord::Migration[6.1]
  def change
    remove_column :students, :grade
    add_column :students, :grade ,:integer
  end
end
