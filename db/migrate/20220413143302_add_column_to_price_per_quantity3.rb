class AddColumnToPricePerQuantity3 < ActiveRecord::Migration[6.1]
  def change
    add_column :qty_price, :qty, :integer
  end
end
