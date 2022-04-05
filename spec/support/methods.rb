require "csv"
require "date"

def user_seed
  @user = User.create(
    username: "城南ゼミナール",
    email: "1@gmail.com",
    password: "111111"
  )
end

def students_seed
  @students = []
  CSV.foreach("db/seed_student.csv", encoding: 'UTF-8') do |line|
    @students << @user.students.build(
      user_id: line[0],
      start_date: line[1],
      class_name: line[2],
      family_name: line[3],
      given_name: line[4],
      family_name_kana: line[5],
      given_name_kana: line[6],
      gender: line[7],
      birth_date: line[8],
      school_belong_to: line[9],
      grade: line[10],
      guardian_family_name: line[11],
      guardian_given_name: line[12],
      guardian_family_name_kana: line[13],
      guardian_given_name_kana: line[14],
      phone1: line[15],
      phone1_belong_to: line[16],
      phone2: line[17],
      phone2_belong_to: line[18],
      postal_code: line[19],
      address: line[20],
      email: line[21],
      user_name: line[22],
      password_digest: line[23],
      sibling_group: line[24],
      expire_date: "",
      expire_flag: false
      )
  end
end

def item_master_seed
  @item_masters = []
  CSV.foreach("db/seed_item_master.csv", encoding: 'UTF-8') do |line|
    @item_masters << @user.item_masters.build(
      user_id: line[0],
      code: line[1],
      category: line[2],
      name: line[3],
      price: line[4],
      description: line[5]
    )
  end
end

def student_registration(student)
  click_link "新規登録"
  expect(page).to have_content('生徒の新規登録')
  fill_in "student_start_date", with: student.start_date
  fill_in "student_class_name", with: student.class_name
  fill_in "student_family_name", with: student.family_name
  fill_in "student_given_name", with: student.given_name
  fill_in "student_family_name_kana", with: student.family_name_kana
  fill_in "student_given_name_kana", with: student.given_name_kana
  select student.gender, from: "student_gender"
  fill_in "student_birth_date", with: student.birth_date
  fill_in "student_school_belong_to", with: student.school_belong_to
  select "中学３年", from: "student_grade"
  fill_in "student_guardian_family_name", with: student.guardian_family_name
  fill_in "student_guardian_given_name", with: student.guardian_given_name
  fill_in "student_guardian_family_name_kana", with: student.guardian_family_name_kana
  fill_in "student_guardian_given_name_kana", with: student.guardian_given_name_kana
  fill_in "student_phone1", with: student.phone1
  fill_in "student_phone1_belong_to", with: student.phone1_belong_to
  fill_in "student_phone2", with: student.phone2
  fill_in "student_phone2_belong_to", with: student.phone2_belong_to
  fill_in "student_postal_code", with: student.postal_code
  fill_in "student_address", with: student.address
  fill_in "student_email", with: student.email
  fill_in "student_user_name", with: student.user_name
  fill_in "student_password", with: student.password
  fill_in "student_remarks", with: student.remarks
  click_button "生徒を登録する"
end

def items_master_registration(item_master)
  visit root_path
  click_link "講座"
  click_link "新規登録"
  fill_in "item_master_code", with: item_master.code
  fill_in "item_master_category", with: item_master.category
  fill_in "item_master_name", with: item_master.name
  fill_in "item_master_price", with: item_master.price
  fill_in "item_master_description", with: item_master.description
  click_button "講座を登録する"
end