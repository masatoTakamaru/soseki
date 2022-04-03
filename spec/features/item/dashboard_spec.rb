require "rails_helper"
feature "ダッシュボード", type: :feature do
  before do
    user_seed
    students_seed
    visit "users/sign_in"
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    find('input[name="commit"]').click
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
    students_seed
    student = @students.first
    student_registration(student)
    click_link "ダッシュボード"
    expect(page).not_to have_content("生徒が登録されていません。")
  end

  scenario "講座が存在する場合エラーメッセージが表示されない" do
    user_seed
    item_master_seed
    item_master = @item_masters.first
    click_link "講座"
    click_link "新規登録"
    fill_in "item_master_code", with: item_master.code 
    fill_in "item_master_category", with: item_master.category
    fill_in "item_master_name", with: item_master.name
    fill_in "item_master_price", with: item_master.price
    fill_in "item_master_description", with: item_master.description
    click_button "講座を登録する"
    expect(page).to have_content("新規講座が登録されました。")
    click_link "ダッシュボード"
    expect(page).not_to have_content("講座が登録されていません。")
  end

end