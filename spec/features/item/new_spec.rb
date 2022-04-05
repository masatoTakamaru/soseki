require "rails_helper"
feature "帳簿の新規登録", type: :feature do
  before do
    user_seed
    students_seed
    item_master_seed
    visit "users/sign_in"
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    find('input[name="commit"]').click
    student = @students.first
    student_registration(student)
    item_master = @item_masters.first
    items_master_registration(item_master)
    click_link "ダッシュボード"
    click_button "新規登録"
    click_link "沼田 寧花"
  end

  scenario "タイトルが正しく表示される" do
    expect(page).to have_title("月謝の登録")
  end

  scenario "見出しが正しく表示される" do
    expect(page).to have_content("月謝の登録")
  end


end