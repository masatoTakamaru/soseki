class AddColumnToPostal < ActiveRecord::Migration[6.1]
  def change
    add_column :postals, :postal_code, :integer
    add_column :postals, :prefecture, :string
    add_column :postals, :city, :string
    add_column :postals, :town, :string
  end
end
