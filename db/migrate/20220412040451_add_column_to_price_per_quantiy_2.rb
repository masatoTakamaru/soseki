class AddColumnToPricePerQuantiy2 < ActiveRecord::Migration[6.1]
  def change
    add_column :qty_price, :user_id, :integer
  end
end
