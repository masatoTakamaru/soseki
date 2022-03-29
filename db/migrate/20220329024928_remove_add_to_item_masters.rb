class RemoveAddToItemMasters < ActiveRecord::Migration[6.1]
  def change
    remove_column :item_masters, :class_name
    add_column :item_masters, :code, :integer
  end
end
