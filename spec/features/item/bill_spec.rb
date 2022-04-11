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
    click_link "沼田 寧花"
  end

  scenario "タイトルが正しく表示される" do
    expect(page).to have_title("月謝の登録")
  end

  scenario "見出しが正しく表示される" do
    expect(page).to have_content("月謝の登録")
  end

  scenario "講座の検索が表示される" do
    expect(page).to have_content("講座の検索")
    expect(page).to have_content("講座コードで検索")
  end

  scenario "登録講座がない場合メッセージが表示される" do
    expect(page).to have_content("講座が登録されていません。")
  end

  scenario "講座の検索結果が正しく表示される" do
    fill_in "code", with: 1011
    click_button "検索"
    expect(page).to have_content("中１国語")
  end

  scenario "コードによる検索に該当しないコードを入力するとエラーが表示される" do
    fill_in "code", with: 9000
    click_button "検索"
    expect(page).to have_content("講座が見つかりません。")
  end

  scenario "追加をクリックすると講座が登録される" do
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    expect(current_user.items.first).not_to eq be_empty
  end

  scenario "削除をクリックすると講座が削除される" do
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    click_button "削除"
    expect(page).to have_content("講座が登録されていません。")
  end

  scenario "合計の計算が正しく行われる" do
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    expect(page).to have_content("22,000")
  end

end