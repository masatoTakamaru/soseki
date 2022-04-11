require 'rails_helper'

feature "生徒の情報", type: :feature do
  let(:current_user) {user_seed}
  let(:item_master) {item_master_seed}
  let(:students) {students_seed}
  let(:item) {item_seed}
  let(:student) {students_seed.first}
  let(:student2) {students_seed.second}

  before do
    visit "users/sign_in"
    fill_in "user_email", with: current_user.email
    fill_in "user_password", with: current_user.password
    find("input[name='commit']").click
    click_link "生徒"
    student_registration(student)
    student_registration(student2)
  end

  scenario "卒・退会者ページのタイトルが正しく表示される" do
    click_link "卒・退会者"
    expect(page).to have_title("卒・退会者")
  end

  scenario "卒・退会ができる" do
    click_link "沼田 寧花"
    expect(page).to have_content("生徒の編集")
    fill_in "student_expire_date", with: "2022-4-1"
    click_button "卒・退会"
    expect(page).to have_content("卒・退会名簿に移動しました。")
    expect(current_path).to eq student_index_path
    expect(page).not_to have_content("沼田 寧花")
  end

  scenario "卒・退会日が入力できる" do
    click_link "沼田 寧花"
    expect(page).to have_content("生徒の編集")
    fill_in "student_expire_date", with: "2010-4-1"
    click_button "卒・退会"
    expect(current_path).to eq student_index_path
    expect(page).to have_content("卒・退会名簿に移動しました。")
    click_link "卒・退会者"
    expect(page).to have_content("沼田 寧花")
    expect(page).to have_content("2010-04-01")
  end

  scenario "卒・退会の取り消しができる" do
    click_link "沼田 寧花"
    expect(page).to have_content("生徒の編集")
    fill_in "student_expire_date", with: "2010-4-1"
    click_button "卒・退会"
    expect(current_path).to eq student_index_path
    click_link "卒・退会者"
    click_link "沼田 寧花"
    click_link "取り消し"
    expect(current_path).to eq student_index_path
    expect(page).to have_content("沼田 寧花")
  end

  scenario "生徒の削除ができる" do
    click_link "沼田 寧花"
    expect(page).to have_content("生徒の編集")
    click_link "生徒の削除"
    expect(current_path).to eq student_index_path
    expect(page).not_to have_content("沼田 寧花")
  end
end

feature "卒・退会者", type: :feature do
  let(:current_user) {user_seed}
  let(:item_master) {item_master_seed}
  let(:students) {students_seed}
  let(:item) {item_seed}
  let(:student2) {students_seed.second}

  before do
    visit "users/sign_in"
    fill_in "user_email", with: current_user.email
    fill_in "user_password", with: current_user.password
    find("input[name='commit']").click
    click_link "生徒"
    student_registration(student2)
  end

  scenario "卒・退会者一覧にページネーションが表示される" do
    100.times do
      student = students_seed.first
      student[:expire_flag] = true
      current_user.students << student
    end
    click_link "生徒"
    click_link "卒・退会者"
    expect(page).to have_content("卒・退会者:100人")
    expect(page).to have_content("次")
    expect(page).to have_content("最後")
  end

  scenario "卒・退会者の上限を超えた場合エラーが表示される" do
    200.times do
      student = students_seed.first
      student[:expire_flag] = true
      current_user.students << student
    end
    click_link "生徒"
    click_link "滝田 柚海子"
    click_button "卒・退会"
    expect(page).to have_content("卒・退会者が上限に達しています。")
  end
end