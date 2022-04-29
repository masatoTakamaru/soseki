require 'rails_helper'

describe "兄弟姉妹の設定", type: :system do
  let(:current_user) {user_seed}
  let(:item_master) {item_master_seed}
  let(:students) {student_seed}
  let(:item) {item_seed}
  let(:student) {student_seed.first}
  let(:student2) {student_seed.second}

  before do
    visit "users/sign_in"
    fill_in "user_email", with: current_user.email
    fill_in "user_password", with: current_user.password
    find("input[name='commit']").click
    click_link "生徒"
    reg_student(student)
    reg_student(student2)
    click_link "生徒"
    click_link "沼田 寧花"
    click_link "兄弟姉妹の設定"
  end

  it "タイトルが正しく表示される" do
    expect(page).to have_title("兄弟姉妹の設定")
  end

  it "兄弟姉妹が表示される" do
    within "table" do
      expect(page).to have_content("滝田 柚海子")
    end
  end

  it "本人は表示されない" do
    within "table" do
      expect(page).not_to have_content("沼田 寧花")
    end
  end

  it "兄弟姉妹の設定ができる" do
    click_button "設定"
    expect(page).to have_content("兄弟姉妹を設定しました。")
    click_button "解除"
    expect(page).to have_content("設定を解除しました。")
  end

  it "生徒の情報に戻れる" do
    click_link "戻る"
    expect(page).to have_content("生徒の情報")
  end

  it "生徒の情報に兄弟姉妹が表示される" do
    click_button "設定"
    click_link "戻る"
    expect(page).to have_content("滝田 柚海子")
  end

  it "兄弟姉妹を解除すると生徒の情報に兄弟姉妹が表示されない" do
    click_button "設定"
    click_link "戻る"
    expect(page).to have_content("滝田 柚海子")
    click_link "兄弟姉妹の設定"
    click_button "解除"
    click_link "戻る"
    expect(page).not_to have_content("滝田 柚海子")
  end

end