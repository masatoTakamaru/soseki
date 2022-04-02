require "rails_helper"
feature "ダッシュボード", type: :feature do
  let(:student) { FactoryBot.build(:student) }
  before do
    #アカウント登録
    visit root_path
    click_link "新規登録はこちらから"
    fill_in "user_username", with: "東京ゼミナール"
    fill_in "user_email", with: "1@gmail.com"
    fill_in "user_password", with: "111111"
    fill_in "user_password_confirmation", with: "111111"
    click_button "アカウント登録"
    expect(page).to have_content("アカウント登録が完了しました。")
  end

  scenario "タイトルが正しく表示される" do
    click_link "ダッシュボード"
    expect(page).to have_title("ダッシュボード")
  end

  scenario "生徒が存在しない場合メッセージが表示される" do
    click_link "ダッシュボード"
    expect(page).to have_content("生徒が登録されていません。")
  end

  scenario "講座が存在しない場合メッセージが表示される" do
    click_link "ダッシュボード"
    expect(page).to have_content("講座が登録されていません。")
  end

  scenario "生徒が存在する場合エラーメッセージが表示されない" do
    #生徒の新規登録
    click_link "生徒"
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
    click_link "ダッシュボード"
    expect(page).not_to have_content("生徒が登録されていません。")
  end

  scenario "講座が存在する場合エラーメッセージが表示されない" do
    #講座の登録
    click_link "講座"
    click_link "新規登録"
    fill_in "item_master_code", with: 1
    fill_in "item_master_category", with: 1
    fill_in "item_master_name", with: "中１国語"
    fill_in "item_master_price", with: 11000
    fill_in "item_master_description", with: "なし"
    click_button "講座を登録する"
    expect(page).to have_content("新規講座が登録されました。")
    click_link "ダッシュボード"
    expect(page).not_to have_content("講座が登録されていません。")
  end


end