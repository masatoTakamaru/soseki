class CreatePostals < ActiveRecord::Migration[6.1]
  def change
    create_table :postals do |t|
      t.timestamps
    end
  end
end
