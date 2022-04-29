require 'rails_helper'

describe "ホーム画面", type: :system do

  let(:current_user) {user_seed}

  it "ホームページが表示される" do
    visit root_path
    expect(page).to have_content "Soseki"
    expect(page).to have_content "ログイン" 
    expect(page).to have_content "ヘルプ" 
    expect(page).to have_content "新規登録はこちらから"
    expect(page).to have_content "プライバシーポリシー"
    expect(page).to have_content "お問い合わせ"
  end

  it "ロゴをクリックするとホームに移動する" do
    visit root_path
    click_link "Soseki"
    expect(page).to have_content "Soseki"
    expect(page).to have_content "ログイン" 
    expect(page).to have_content "ヘルプ" 
    expect(page).to have_content "新規登録はこちらから"
    expect(page).to have_content "プライバシーポリシー"
    expect(page).to have_content "お問い合わせ"
  end

  it "ログインをクリックするとログイン画面に移動する" do
    visit root_path
    click_link "ログイン"
    expect(page).to have_content "ログイン"
    expect(page).to have_content "Eメール"
    expect(page).to have_content "パスワード"
    expect(page).to have_content "アカウント登録"
    expect(page).to have_content "パスワードを忘れましたか？"
  end

  it "ログインができる" do
    visit "users/sign_in"
    # emailを入力する
    fill_in 'user_email', with: current_user.email
    # パスワードを入力する
    fill_in 'user_password', with: current_user.password
    # ログインボタンをおす
    find('input[name="commit"]').click
    expect(page).to have_content('ログインしました。')
  end

end