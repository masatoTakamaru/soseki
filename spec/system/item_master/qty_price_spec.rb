require 'rails_helper'

describe "従量課金の設定", type: :system do

  let(:current_user) {user_seed}
  let(:item_master) {item_master_seed}
  let(:students) {student_seed}
  let(:item) {item_seed}
  let(:student) {student_seed.first}

  before do
    visit "users/sign_in"
    fill_in "user_email", with: current_user.email
    fill_in "user_password", with: current_user.password
    find("input[name='commit']").click
    current_user.students << student
    click_link "講座と費用"
  end

  it "従量課金が設定できる" do
    click_link "設定"
    expect(page).to have_title("設定")
    expect(page).to have_content("設定")
    expect(page).to have_content("従量課金")
    expect(page).to have_content("講座数に応じた料金設定")
    fill_in "price1", with: 11000
    fill_in "price2", with: 11000
    fill_in "price3", with: 11000
    fill_in "price4", with: 11000
    fill_in "price5", with: 11000
    fill_in "price6", with: 11000
    fill_in "price7", with: 11000
    fill_in "price8", with: 11000
    fill_in "price9", with: 11000
    fill_in "price10", with: 11000
    fill_in "price11", with: 11000
    fill_in "price12", with: 11000
    click_button "更新"
    expect(page).to have_content("価格を更新しました。")
  end

  it "価格が負の数はNG" do
    click_link "設定"
    expect(page).to have_title("設定")
    expect(page).to have_content("設定")
    expect(page).to have_content("従量課金")
    expect(page).to have_content("講座数に応じた料金設定")
    fill_in "price1", with: -11000
    click_button "更新"
    expect(page).to have_content("更新が失敗しました。価格は0以上の値を入力して下さい。")
  end

  it "価格が小数はOK" do
    click_link "設定"
    expect(page).to have_title("設定")
    expect(page).to have_content("設定")
    expect(page).to have_content("従量課金")
    expect(page).to have_content("講座数に応じた料金設定")
    fill_in "price1", with: 1.5
    click_button "更新"
    expect(page).to have_content("価格を更新しました。")
  end

  it "価格が数値以外はNG" do
    click_link "設定"
    expect(page).to have_title("設定")
    expect(page).to have_content("設定")
    expect(page).to have_content("従量課金")
    expect(page).to have_content("講座数に応じた料金設定")
    fill_in "price1", with: "+1.5"
    click_button "更新"
    expect(page).to have_content("更新が失敗しました。価格は0以上の値を入力して下さい。")
  end

  it "キャンセルをクリックしたら費用と講座に戻る" do
    click_link "設定"
    click_link "キャンセル"
    expect(current_path).to eq item_master_index_path
  end

end