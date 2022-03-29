class AddColumnToItemMasters < ActiveRecord::Migration[6.1]
  def change
    add_column :item_masters, :user_id, :integer
  end
end
