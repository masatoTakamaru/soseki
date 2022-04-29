require "rails_helper"
describe "帳簿の新規登録", type: :system do

  let(:current_user) {user_seed}
  let(:item_master) {item_master_seed}
  let(:students) {student_seed}
  let(:item) {item_seed}
  let(:student) {student_seed.first}

  before do
    user_login
    current_user.students << student
    current_user.item_masters << item_master.first
    click_link "ダッシュボード"
    fill_in "year", with: 2022
    fill_in "month", with: 4
    click_button "新規登録"
  end

  it "タイトルが正しく表示される" do
    expect(page).to have_title("台帳")
  end

  it "見出しが正しく表示される" do
    expect(page).to have_content("台帳")
    expect(page).to have_content("2022 年 4 月")
  end

  it "生徒数が表示される" do
    expect(page).to have_content("生徒数")
    expect(page).to have_content("1人")
  end

  it "リストの並べ替えが表示されない" do
    expect(page).not_to have_content("並べ替え")
  end

  it "生徒名が表示される" do
    expect(page).to have_content("沼田 寧花")
  end
  
  it "戻るをクリックするとダッシュボードに戻る" do
    click_link "戻る"
    expect(current_path).to eq dashboard_path
  end
end