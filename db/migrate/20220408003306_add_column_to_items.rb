class AddColumnToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :code, :integer
  end
end
