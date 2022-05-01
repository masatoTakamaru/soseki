require "csv"
require "date"

def user_seed
  User.create(
    username: "城南ゼミナール",
    email: "1@gmail.com",
    password: "111111"
  )
end

def student_seed
  students = []
  CSV.foreach("db/seed_student.csv", encoding: 'UTF-8') do |line|
    students << Student.new(
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
      email: line[21],
      sibling_group: line[24],
      expire_date: "",
      expire_flag: false
      )
  end
  students
end

def item_master_seed
  item_masters = []
  CSV.foreach("db/seed_item_master.csv", encoding: 'UTF-8') do |line|
    item_masters << ItemMaster.new(
      code: line[1],
      category: line[2],
      name: line[3],
      price: line[4],
      description: line[5]
    )
  end
  item_masters
end

def item_seed
  items = []
  CSV.foreach("db/seed_item.csv", encoding: 'UTF-8') do |line|
    items << Item.new(
      period: line[1],
      code: line[2],
      category: line[3],
      name: line[4],
      price: line[5],
      description: line[6]
    )
  end
  items
end

def qty_price_seed
  qty_prices = []
  0.upto(16){|grade|
    1.upto(12){|qty|
      price = (8000+grade*200)*(1-0.9**qty)/(1-0.9)/100
      price = price.to_i
      price = price * 100
      qty_prices << QtyPrice.new(
        grade: grade,
        qty: qty,
        price: price)
    }
  }
  qty_prices
end

def reg_student(e)
  grades = {
    "未就学": 0, "年少": 1, "年中": 2,
    "年長": 3, "小学１年": 4, "小学２年": 5,
    "小学３年": 6, "小学４年": 7, "小学５年": 8,
    "小学６年": 9, "中学１年": 10, "中学２年": 11,
    "中学３年": 12, "高校１年": 13, "高校２年": 14,
    "高校３年": 15, "既卒": 16}
  grade_name = grades.keys
  visit root_path
  click_link "生徒"
  click_link "新規登録"
  expect(page).to have_content('生徒の新規登録')
  fill_in "student_start_date", with: e[:start_date]
  fill_in "student_class_name", with: e[:class_name]
  fill_in "student_family_name", with: e[:family_name]
  fill_in "student_given_name", with: e[:given_name]
  fill_in "student_family_name_kana", with: e[:family_name_kana]
  fill_in "student_given_name_kana", with: e[:given_name_kana]
  select e[:gender], from: "student_gender"
  fill_in "student_birth_date", with: e[:birth_date]
  fill_in "student_school_belong_to", with: e[:school_belong_to]
  select grade_name[e[:grade]], from: "student_grade"
  fill_in "student_guardian_family_name", with: e[:guardian_family_name]
  fill_in "student_guardian_given_name", with: e[:guardian_given_name]
  fill_in "student_guardian_family_name_kana", with: e[:guardian_family_name_kana]
  fill_in "student_guardian_given_name_kana", with: e[:guardian_given_name_kana]
  fill_in "student_phone1", with: e[:phone1]
  fill_in "student_phone1_belong_to", with: e[:phone1_belong_to]
  fill_in "student_phone2", with: e[:phone2]
  fill_in "student_phone2_belong_to", with: e[:phone2_belong_to]
  click_button "生徒を登録する"
  expect(page).to have_content("新規生徒が登録されました。")
end

def reg_items_master(e)
  visit root_path
  click_link "講座と費用"
  click_link "新規登録"
  expect(page).to have_content("項目の新規登録")
  if e[:category] == 1
    click_link "従量"
    fill_in "item_master_code", with: e[:code]
    fill_in "item_master_name", with: e[:name]
    fill_in "item_master_description", with: e[:description]
    click_button "項目を登録する"
  elsif e[:category] == 2
    click_link "単独"
    fill_in "item_master_code", with: e[:code]
    fill_in "item_master_name", with: e[:name]
    fill_in "item_master_price", with: e[:price]
    fill_in "item_master_description", with: e[:description]
    click_button "項目を登録する"
  elsif e[:category] == 3
    click_link "諸費"
    fill_in "item_master_code", with: e[:code]
    fill_in "item_master_name", with: e[:name]
    fill_in "item_master_price", with: e[:price]
    fill_in "item_master_description", with: e[:description]
    click_button "項目を登録する"
  elsif e[:category] == 4
    click_link "割引"
    fill_in "item_master_code", with: e[:code]
    fill_in "item_master_name", with: e[:name]
    fill_in "item_master_price", with: e[:price]
    fill_in "item_master_description", with: e[:description]
    click_button "項目を登録する"
  end
end

def reg_qty_price
  grades = {
    "未就学": 0, "年少": 1, "年中": 2,
    "年長": 3, "小学１年": 4, "小学２年": 5,
    "小学３年": 6, "小学４年": 7, "小学５年": 8,
    "小学６年": 9, "中学１年": 10, "中学２年": 11,
    "中学３年": 12, "高校１年": 13, "高校２年": 14,
    "高校３年": 15, "既卒": 16}
  grade_name = grades.keys
  0.upto(16){|grade|
    visit root_path
    click_link "講座と費用"
    click_link "設定"
    select grade_name[grade], from: "grade"
    click_button "選択"
    1.upto(12){|qty|
      price = (8000+grade*200)*(1-0.9**qty)/(1-0.9)/100
      price = price.to_i
      price = price * 100
      fill_in "price" + qty.to_s, with: price
    }
    click_button "更新"
  }
end

def user_login
  visit "users/sign_in"
  fill_in "user_email", with: current_user.email
  fill_in "user_password", with: current_user.password
  find("input[name='commit']").click
end