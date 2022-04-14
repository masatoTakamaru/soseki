class ChangeColumnQtyPrice < ActiveRecord::Migration[6.1]
  def change
    change_column :qty_prices, :price, :float
  end
end
