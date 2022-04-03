require 'rails_helper'

feature "生徒の登録", type: :feature do

  before do
    #ユーザーを作成してログイン
    user_seed
    visit "users/sign_in"
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    find('input[name="commit"]').click
  end

  scenario "生徒の新規登録ができる" do
    expect(page).to have_content('ログインしました。')
    expect(page).to have_content('生徒は登録されていません。')
    expect(page).to have_content('新規登録')
    #新規登録
    students_seed
    student = @students.first
    student_registration(student)
    expect(page).to have_content('生徒数')
    expect(page).to have_content('沼田')
  end

  scenario "生徒を30人まで登録できる" do
    students_seed
    student = @students.first
    30.times do |i|
      student_registration(student)
    end
    expect(page).to have_content('30人')
  end

  scenario "生徒を31人登録はNG" do
    students_seed
    student = @students.first
    30.times do |i|
      student_registration(student)
    end
    click_link "新規登録"
    expect(page).to have_content('登録できる生徒の上限に達しています。')
    expect(current_path).to eq student_index_path
  end

  scenario "卒・退会者名簿に移動できる" do
    students_seed
    student = @students.first
    student_registration(student)
    click_link "卒・退会者"
    expect(current_path).to eq student_expired_path
  end

  scenario "卒・退会者名簿から生徒一覧に戻れる" do
    students_seed
    student = @students.first
    student_registration(student)
    click_link "卒・退会者"
    click_link "戻る"
    expect(current_path).to eq student_index_path
  end

end