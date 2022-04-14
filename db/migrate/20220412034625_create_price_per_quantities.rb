class CreatePricePerQuantities < ActiveRecord::Migration[6.1]
  def change
    create_table :qty_price do |t|

      t.integer "quantity"
      t.integer "price"
      t.timestamps
    end
  end
end
