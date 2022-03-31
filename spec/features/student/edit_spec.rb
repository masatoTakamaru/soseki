require 'rails_helper'
require "spec_helper"

feature "student_edit", type: :feature do

  let(:user) { FactoryBot.create(:user) }
  let(:student) { FactoryBot.build(:student) }

  before do
    visit "users/sign_in"
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    find('input[name="commit"]').click
    expect(page).to have_content('ログインしました。')
    expect(page).to have_content('生徒は登録されていません。')
    expect(page).to have_content('新規登録')
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
    visit student_index_path
    click_link "田中 太郎"
    click_link "生徒の編集"
  end

  scenario "入会日が変更できる" do
    fill_in "student_start_date", with: "2022-10-01"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "生徒姓が変更できる" do
    fill_in "student_family_name", with: "佐藤"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "生徒名が変更できる" do
    fill_in "student_given_name", with: "次郎"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "生徒姓カナが変更できる" do
    fill_in "student_family_name_kana", with: "サトウ"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "生徒名カナが変更できる" do
    fill_in "student_given_name_kana", with: "ジロウ"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "生年月日が変更できる" do
    fill_in "student_birth_date", with: "2008-5-11"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "学校名が変更できる" do
    fill_in "student_school_belong_to", with: "桜丘中"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "保護者姓が変更できる" do
    fill_in "student_guardian_family_name", with: "サトウ"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "保護者名が変更できる" do
    fill_in "student_guardian_given_name", with: "次郎"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end
  
  scenario "保護者姓カナが変更できる" do
    fill_in "student_guardian_family_name_kana", with: "サトウ"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "保護者名カナが変更できる" do
    fill_in "student_guardian_given_name_kana", with: "ジロウ"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "電話番号１が変更できる" do
    fill_in "student_phone1", with: "092-123-4567"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "電話番号１の続柄が変更できる" do
    fill_in "student_phone1_belong_to", with: "本人"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "電話番号２が変更できる" do
    fill_in "student_phone2", with: "080-1234-5678"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "電話番号２の続柄が変更できる" do
    fill_in "student_phone2_belong_to", with: "母"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "郵便番号が変更できる" do
    fill_in "student_postal_code", with: "8410047"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "住所が変更できる" do
    fill_in "student_address", with: "京都府"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "メールアドレスが変更できる" do
    fill_in "student_email", with: "a@gmail.com"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "パスワードが変更できる" do
    fill_in "student_password", with: "tanaka"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "備考欄が変更できる" do
    fill_in "student_remarks", with: "tanaka"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  scenario "キャンセルできる" do
    click_link "キャンセル"
    expect(page).to have_content("生徒の情報")
  end

  

end