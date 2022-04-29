require "rails_helper"
describe "ダッシュボード", type: :system do

  let(:current_user) {user_seed}
  let(:item_masters) {item_master_seed}
  let(:students) {student_seed}
  let(:qty_prices) {qty_price_seed}
  let(:students) {student_seed}

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

  it "ログイン後にダッシュボードに移動する" do
    expect(page).to have_content("ログインしました。")
    expect(current_path).to eq dashboard_path
  end

  it "タイトルが正しく表示される" do
    expect(page).to have_title("ダッシュボード")
  end

  it "生徒も項目も存在しない場合メッセージが表示される" do
    expect(page).to have_content("生徒または項目が登録されていません。")
  end

  it "生徒が存在し項目が存在しない場合メッセージが表示される" do
    current_user.students << students
    click_link "ダッシュボード"
    expect(page).to have_content("生徒または項目が登録されていません。")
  end

  it "講座が存在する場合エラーメッセージが表示されない" do
    current_user.students << students
    current_user.item_masters << item_masters.first
    click_link "ダッシュボード"
    expect(page).not_to have_content("生徒または項目が登録されていません。")
  end

  it "帳簿が存在しない場合メッセージが表示される" do
    current_user.students << students
    current_user.item_masters << item_masters.first
    click_link "ダッシュボード"
    expect(page).to have_content("台帳が存在しません。「新規登録」をクリックして台帳を作成して下さい。")
  end

  it "台帳のタイトルが正しく表示される" do
    current_user.students << students
    current_user.item_masters << item_masters.first
    click_link "ダッシュボード"
    click_button "新規登録"
    expect(page).to have_title("台帳")
    expect(page).to have_content("沼田 寧花")
  end
end