class AddColumnToQtyPrices < ActiveRecord::Migration[6.1]
  def change
    add_column :qty_prices, :grade, :integer
  end
end
