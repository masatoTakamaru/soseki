class Chance < ActiveRecord::Migration[6.1]
  def change
    rename_table :price_qtys, :qty_prices

  end
end
