require 'rails_helper'

feature "student", type: :feature do

  let(:user) { FactoryBot.create(:user) }
  let(:student) { FactoryBot.build(:student) }

  before do
    visit "users/sign_in"
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    find('input[name="commit"]').click
  end

  scenario "生徒の新規登録ができる" do
    expect(page).to have_content('ログインしました。')
    expect(page).to have_content('生徒は登録されていません。')
    expect(page).to have_content('新規登録')
    #新規登録
    click_link "新規登録"
    expect(page).to have_content('生徒の新規登録')
    fill_in "student_start_date", with: student.start_date
    fill_in "student_expire_date", with: student.expire_date
    check "student_expire_flag"
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
    expect(page).to have_content('生徒数')
    expect(page).to have_content('田中')
  end

  scenario "生徒を30人まで登録できる" do
    30.times do |i|
      click_link "新規登録"
      expect(page).to have_content('生徒の新規登録')
      fill_in "student_start_date", with: student.start_date
      fill_in "student_expire_date", with: student.expire_date
      check "student_expire_flag"
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
  end

  scenario "生徒を31人登録はNG" do
    30.times do |i|
      click_link "新規登録"
      expect(page).to have_content('生徒の新規登録')
      fill_in "student_start_date", with: student.start_date
      fill_in "student_expire_date", with: student.expire_date
      check "student_expire_flag"
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
    click_link "新規登録"
    expect(page).to have_content('登録できる生徒の上限に達しています。')
    expect(current_path).to eq student_index_path
  end



end