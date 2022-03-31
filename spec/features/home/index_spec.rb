require 'rails_helper'

feature "ホーム画面", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  scenario "ホームページが表示される" do
    visit root_path
    expect(page).to have_content "Soseki"
    expect(page).to have_content "ログイン" 
    expect(page).to have_content "ヘルプ" 
    expect(page).to have_content "新規登録はこちらから"
    expect(page).to have_content "プライバシーポリシー"
    expect(page).to have_content "お問い合わせ"
  end

  scenario "ロゴをクリックするとホームに移動する" do
    visit root_path
    click_link "Soseki"
    expect(page).to have_content "Soseki"
    expect(page).to have_content "ログイン" 
    expect(page).to have_content "ヘルプ" 
    expect(page).to have_content "新規登録はこちらから"
    expect(page).to have_content "プライバシーポリシー"
    expect(page).to have_content "お問い合わせ"
  end

  scenario "ログインをクリックするとログイン画面に移動する" do
    visit root_path
    click_link "ログイン"
    expect(page).to have_content "ログイン"
    expect(page).to have_content "Eメール"
    expect(page).to have_content "パスワード"
    expect(page).to have_content "アカウント登録"
    expect(page).to have_content "パスワードを忘れましたか？"
  end

  scenario "ログインができる" do
    visit "users/sign_in"
    # emailを入力する
    fill_in 'user_email', with: user.email
    # パスワードを入力する
    fill_in 'user_password', with: user.password
    # ログインボタンをおす
    find('input[name="commit"]').click
    expect(page).to have_content('ログインしました。')
    expect(page).to have_content('生徒は登録されていません。')
    expect(page).to have_content('新規登録')
  end

end