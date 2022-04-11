require "rails_helper"

feature "アカウント登録", type: :feature do
  scenario "タイトルが正しく表示される" do
    visit root_path
    click_link "新規登録はこちらから"
    expect(page).to have_title("アカウント登録")
  end

  scenario "見出しが正しく表示される" do
    visit root_path
    click_link "新規登録はこちらから"
    expect(page).to have_content("アカウント登録")
  end

  scenario "利用規約が表示される" do
    visit root_path
    click_link "新規登録はこちらから"
    expect(page).to have_content("利用規約")
  end

  scenario "アカウントが登録できる" do
    visit root_path
    click_link "新規登録はこちらから"
    fill_in "user_username", with: "東京ゼミナール"
    fill_in "user_email", with: "test@gmail.com"
    fill_in "user_password", with: "123456"
    fill_in "user_password_confirmation", with: "123456"
    click_button "アカウント登録"
    expect(current_path).to eq dashboard_path
  end

  scenario "アカウントページのタイトルが正しく表示される" do
    visit root_path
    click_link "新規登録はこちらから"
    fill_in "user_username", with: "東京ゼミナール"
    fill_in "user_email", with: "test@gmail.com"
    fill_in "user_password", with: "123456"
    fill_in "user_password_confirmation", with: "123456"
    click_button "アカウント登録"
    click_link "東京ゼミナール"
    expect(page).to have_title("東京ゼミナール")
  end
    
  scenario "アカウントページの見出しが正しく表示される" do
    visit root_path
    click_link "新規登録はこちらから"
    fill_in "user_username", with: "東京ゼミナール"
    fill_in "user_email", with: "test@gmail.com"
    fill_in "user_password", with: "123456"
    fill_in "user_password_confirmation", with: "123456"
    click_button "アカウント登録"
    click_link "東京ゼミナール"
    expect(page).to have_content("東京ゼミナール")
  end

  scenario "アカウントの削除ができる" do
    visit root_path
    click_link "新規登録はこちらから"
    fill_in "user_username", with: "東京ゼミナール"
    fill_in "user_email", with: "test@gmail.com"
    fill_in "user_password", with: "123456"
    fill_in "user_password_confirmation", with: "123456"
    click_button "アカウント登録"
    click_link "東京ゼミナール"
    click_link "登録を解除する"
    expect(page).to have_content("アカウントを削除しました。またのご利用をお待ちしております。")
  end

  scenario "削除したアカウントにはログインできない" do
    visit root_path
    click_link "新規登録はこちらから"
    fill_in "user_username", with: "東京ゼミナール"
    fill_in "user_email", with: "test@gmail.com"
    fill_in "user_password", with: "123456"
    fill_in "user_password_confirmation", with: "123456"
    click_button "アカウント登録"
    click_link "東京ゼミナール"
    click_link "登録を解除する"
    click_link "ログイン"
    fill_in "user_email", with: "test@gmail.com"
    fill_in "user_password", with: "123456"
    click_button "ログイン"
    expect(page).to have_content("Eメールまたはパスワードが違います。")
  end

  scenario "同じメールアドレスでユーザー登録はNG" do
    #first user
    visit root_path
    click_link "新規登録はこちらから"
    fill_in "user_username", with: "東京ゼミナール"
    fill_in "user_email", with: "test@gmail.com"
    fill_in "user_password", with: "123456"
    fill_in "user_password_confirmation", with: "123456"
    click_button "アカウント登録"
    click_link "ログアウト"
    #second user
    click_link "新規登録はこちらから"
    fill_in "user_username", with: "桜ゼミ"
    fill_in "user_email", with: "test@gmail.com"
    fill_in "user_password", with: "123456"
    fill_in "user_password_confirmation", with: "123456"
    click_button "アカウント登録"
    expect(page).to have_content("Eメールはすでに存在します")
  end

  scenario "同じ教室名でユーザー登録はNG" do
    #first user
    visit root_path
    click_link "新規登録はこちらから"
    fill_in "user_username", with: "東京ゼミナール"
    fill_in "user_email", with: "test@gmail.com"
    fill_in "user_password", with: "123456"
    fill_in "user_password_confirmation", with: "123456"
    click_button "アカウント登録"
    click_link "ログアウト"
    #second user
    click_link "新規登録はこちらから"
    fill_in "user_username", with: "東京ゼミナール"
    fill_in "user_email", with: "1@gmail.com"
    fill_in "user_password", with: "123456"
    fill_in "user_password_confirmation", with: "123456"
    click_button "アカウント登録"
    expect(page).to have_content("教室名はすでに存在します")
  end

  scenario "パスワードが6字未満はNG" do
    visit root_path
    click_link "新規登録はこちらから"
    fill_in "user_username", with: "東京ゼミナール"
    fill_in "user_email", with: "test@gmail.com"
    fill_in "user_password", with: "1256"
    fill_in "user_password_confirmation", with: "1256"
    click_button "アカウント登録"
    expect(page).to have_content("スワードは6文字以上で入力してください")
  end


end