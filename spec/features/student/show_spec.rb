require 'rails_helper'

feature "生徒の情報", type: :feature do

  before do
    #ユーザーを作成してログイン
    user_seed
    visit "users/sign_in"
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    find('input[name="commit"]').click
    #生徒を登録
    students_seed
    student = @students.first
    student_registration(student)
    student = @students.second
    student_registration(student)
    #showに移動
    click_link "沼田 寧花"
  end

  scenario "卒・退会者ページのタイトルが正しく表示される" do
    click_button "卒・退会"
    click_link "卒・退会者"
    expect(page).to have_title("卒・退会者")
  end

  scenario "卒・退会ができる" do
    click_button "卒・退会"
    expect(current_path).to eq student_index_path
    expect(page).to have_content("卒・退会名簿に移動しました。")
    click_link "卒・退会者"
    expect(page).to have_content("沼田 寧花")
  end

  scenario "卒・退会日が入力できる" do
    fill_in "student_expire_date", with: "2010-4-1"
    click_button "卒・退会"
    expect(current_path).to eq student_index_path
    expect(page).to have_content("卒・退会名簿に移動しました。")
    click_link "卒・退会者"
    expect(page).to have_content("沼田 寧花")
    expect(page).to have_content("2010-04-01")
  end

  scenario "卒・退会の取り消しができる" do
    fill_in "student_expire_date", with: "2010-4-1"
    click_button "卒・退会"
    click_link "卒・退会者"
    click_link "沼田 寧花"
    click_link "取り消し"
    expect(current_path).to eq student_index_path
    expect(page).to have_content("沼田 寧花")
  end

  scenario "生徒の削除ができる" do
    click_link "生徒の削除"
    expect(current_path).to eq student_index_path
    expect(page).not_to have_content("沼田 寧花")
  end

  scenario "卒・退会者一覧にページネーションが表示される" do
    200.times do
      students_seed
      student = @students.first
      student[:expire_flag] = true
      @user.students << student
    end
    click_link "戻る"
    click_link "卒・退会者"
    expect(page).to have_content("卒・退会者:200人")
    expect(page).to have_content("次")
    expect(page).to have_content("最後")
  end

  scenario "卒・退会者の上限を超えた場合エラーが表示される" do
    200.times do
      students_seed
      student = @students.first
      student[:expire_flag] = true
      @user.students << student
    end
    click_button "卒・退会"
    expect(page).to have_content("卒・退会者が上限に達しています。不要な卒・退会者を削除して下さい。")
  end
end