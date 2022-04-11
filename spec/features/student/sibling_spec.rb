require 'rails_helper'

feature "兄弟姉妹の設定", type: :feature do
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
    click_link "生徒"
    click_link "沼田 寧花"
    click_link "兄弟姉妹の設定"
  end

  scenario "タイトルが正しく表示される" do
    expect(page).to have_title("兄弟姉妹の設定")
  end

  scenario "兄弟姉妹が表示される" do
    within "table" do
      expect(page).to have_content("滝田 柚海子")
    end
  end

  scenario "本人は表示されない" do
    within "table" do
      expect(page).not_to have_content("沼田 寧花")
    end
  end

  scenario "兄弟姉妹の設定ができる" do
    click_button "設定"
    expect(page).to have_content("兄弟姉妹を設定しました。")
    click_button "解除"
    expect(page).to have_content("設定を解除しました。")
  end

  scenario "生徒の情報に戻れる" do
    click_link "戻る"
    expect(page).to have_content("生徒の情報")
  end

  scenario "生徒の情報に兄弟姉妹が表示される" do
    click_button "設定"
    click_link "戻る"
    expect(page).to have_content("滝田 柚海子")
  end

  scenario "兄弟姉妹を解除すると生徒の情報に兄弟姉妹が表示されない" do
    click_button "設定"
    click_link "戻る"
    expect(page).to have_content("滝田 柚海子")
    click_link "兄弟姉妹の設定"
    click_button "解除"
    click_link "戻る"
    expect(page).not_to have_content("滝田 柚海子")
  end

end