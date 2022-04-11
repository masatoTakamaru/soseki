require "rails_helper"
feature "ダッシュボード", type: :feature do

  let(:current_user) {user_seed}
  let(:item_master) {item_master_seed}
  let(:students) {students_seed}
  let(:item) {item_seed}
  let(:student) {students_seed.first}

  before do
    visit "users/sign_in"
    # emailを入力する
    fill_in "user_email", with: current_user.email
    # パスワードを入力する
    fill_in "user_password", with: current_user.password
    # ログインボタンをおす
    find("input[name='commit']").click
    expect(page).to have_content("ログインしました。")
  end

  scenario "ログイン後にダッシュボードに移動する" do
    expect(page).to have_content("ログインしました。")
    expect(current_path).to eq dashboard_path
  end

  scenario "タイトルが正しく表示される" do
    expect(page).to have_title("ダッシュボード")
  end

  scenario "生徒も講座も存在しない場合メッセージが表示される" do
    expect(page).to have_content("生徒または講座が登録されていません。")
  end

  scenario "生徒が存在し講座が存在しない場合メッセージが表示される" do
    current_user.students << student
    click_link "ダッシュボード"
    expect(page).to have_content("生徒または講座が登録されていません。")
  end

  scenario "講座が存在する場合エラーメッセージが表示されない" do
    current_user.students << student
    current_user.item_masters << item_master
    click_link "ダッシュボード"
    expect(page).not_to have_content("生徒または講座が登録されていません。")
  end

  scenario "帳簿が存在しない場合メッセージが表示される" do
    current_user.students << student
    current_user.item_masters << item_master
    click_link "ダッシュボード"
    expect(page).to have_content("帳簿が存在しません。「新規登録」をクリックして帳簿を作成して下さい。")
  end

  scenario "台帳のタイトルが正しく表示される" do
    current_user.students << student
    current_user.item_masters << item_master
    click_link "ダッシュボード"
    click_button "新規登録"
    expect(page).to have_title("台帳")
  end

end