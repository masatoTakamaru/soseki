class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.integer "student_id"
      t.date "period"
      t.string "class_name"
      t.integer "category"
      t.string "name"
      t.float "price"
      t.string "description"

      t.timestamps
    end
  end
end
