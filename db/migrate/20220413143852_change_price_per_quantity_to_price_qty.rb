class ChangePricePerQuantityToPriceQty < ActiveRecord::Migration[6.1]
  def change
    rename_table :qty_price, :qty_price
  end
end
