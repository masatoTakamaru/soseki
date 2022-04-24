# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_04_24_111312) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "item_masters", force: :cascade do |t|
    t.integer "category"
    t.string "name"
    t.float "price"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.integer "code"
  end

  create_table "items", force: :cascade do |t|
    t.integer "student_id"
    t.date "period"
    t.integer "category"
    t.string "name"
    t.float "price"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "code"
  end

  create_table "postals", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "postal_code"
    t.string "prefecture"
    t.string "city"
    t.string "town"
  end

  create_table "qty_prices", force: :cascade do |t|
    t.float "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.integer "qty"
    t.integer "grade"
  end

  create_table "students", force: :cascade do |t|
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "grade"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
