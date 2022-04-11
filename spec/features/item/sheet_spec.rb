require "rails_helper"
feature "帳簿の新規登録", type: :feature do

  let(:current_user) {user_seed}
  let(:item_master) {item_master_seed}
  let(:students) {students_seed}
  let(:item) {item_seed}
  let(:student) {students_seed.first}

  before do
    visit "users/sign_in"
    fill_in "user_email", with: current_user.email
    fill_in "user_password", with: current_user.password
    find("input[name='commit']").click
    current_user.students << student
    current_user.item_masters << item_master
    click_link "ダッシュボード"
    fill_in "year", with: 2022
    fill_in "month", with: 4
    click_button "新規登録"
  end

  scenario "タイトルが正しく表示される" do
    expect(page).to have_title("台帳")
  end

  scenario "見出しが正しく表示される" do
    expect(page).to have_content("台帳")
    expect(page).to have_content("2022 年 4 月")
  end

  scenario "生徒数が表示される" do
    expect(page).to have_content("生徒数")
    expect(page).to have_content("1人")
  end

  scenario "リストの並べ替えが表示される" do
    expect(page).to have_content("並べ替え")
  end

  scenario "生徒名が表示される" do
    expect(page).to have_content("沼田 寧花")
  end
  
  scenario "戻るをクリックするとダッシュボードに戻る" do
    click_link "戻る"
    expect(current_path).to eq dashboard_path
  end
end