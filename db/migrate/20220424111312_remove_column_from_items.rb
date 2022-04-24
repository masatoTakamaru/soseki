class RemoveColumnFromItems < ActiveRecord::Migration[6.1]
  def change
    remove_column :items, :class_name
  end
end
