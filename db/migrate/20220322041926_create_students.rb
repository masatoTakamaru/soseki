class CreateStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :students do |t|
      t.integer "user_id"
      t.date "expire_date"
      t.boolean "expire_flag"
      t.date "start_date"
      t.string "class_name"
      t.string "family_name"
      t.string "given_name"
      t.string "family_name_kana"
      t.string "given_name_kana"
      t.string "gender"
      t.date "birth_date"
      t.string "school_belong_to"
      t.string "grade"
      t.string "guardian_family_name"
      t.string "guardian_given_name"
      t.string "guardian_family_name_kana"
      t.string "guardian_given_name_kana"
      t.string "phone1"
      t.string "phone1_belong_to"
      t.string "phone2"
      t.string "phone2_belong_to"
      t.string "postal_code"
      t.string "address"
      t.string "email"
      t.string "user_name"
      t.string "password_digest"
      t.string "remarks"
      t.string "sibling_group"
  
      t.timestamps
    end
  end
end
