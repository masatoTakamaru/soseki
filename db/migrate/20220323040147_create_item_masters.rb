class CreateItemMasters < ActiveRecord::Migration[6.1]
  def change
    create_table :item_masters do |t|

      t.string "class_name"
      t.integer "category"
      t.string "name"
      t.float "price"
      t.string "description"

      t.timestamps
    end
  end
end
