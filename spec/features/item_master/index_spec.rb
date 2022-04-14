require 'rails_helper'

feature "講座と費用", type: :feature do

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
    click_link "講座と費用"
  end

  scenario "タイトルが正しく表示される" do
    expect(page).to have_title("講座と費用")
  end

  scenario "見出しが正しく表示される" do
    expect(page).to have_content("講座と費用")
  end

  scenario "項目未登録の場合メッセージが表示される" do
    expect(page).to have_content("項目が登録されていません。")
  end

  scenario "新規登録ボタンを押して登録画面に移動できる" do
    click_link "新規登録"
    expect(page).to have_content("項目の新規登録")
  end

  scenario "新規登録のタイトルが正しく表示される" do
    click_link "新規登録"
    expect(page).to have_title("項目の新規登録")
  end

  scenario "単独項目が登録できる" do
    click_link "新規登録"
    fill_in "item_master_code", with: item_master[:code]
    fill_in "item_master_name", with: item_master[:name]
    fill_in "item_master_price", with: item_master[:price]
    fill_in "item_master_description", with: item_master[:description]
    click_button "項目を登録する"
    expect(page).to have_content("項目が登録されました。")
    expect(page).to have_content("単独")
  end

  scenario "従量項目が登録できる" do
    click_link "新規登録"
    click_link "従量"
    fill_in "item_master_code", with: item_master[:code]
    fill_in "item_master_name", with: item_master[:name]
    fill_in "item_master_description", with: item_master[:description]
    click_button "項目を登録する"
    expect(page).to have_content("項目が登録されました。")
    expect(page).to have_content("従量")
  end

  scenario "諸費項目が登録できる" do
    click_link "新規登録"
    click_link "諸費"
    fill_in "item_master_code", with: item_master[:code]
    fill_in "item_master_name", with: item_master[:name]
    fill_in "item_master_price", with: item_master[:price]
    fill_in "item_master_description", with: item_master[:description]
    click_button "項目を登録する"
    expect(page).to have_content("項目が登録されました。")
    expect(page).to have_content("諸費")
  end

  scenario "割引項目が登録できる" do
    click_link "新規登録"
    click_link "割引"
    fill_in "item_master_code", with: item_master[:code]
    fill_in "item_master_name", with: item_master[:name]
    fill_in "item_master_price", with: item_master[:price]
    fill_in "item_master_description", with: item_master[:description]
    click_button "項目を登録する"
    expect(page).to have_content("項目が登録されました。")
    expect(page).to have_content("割引")
  end

  scenario "コードが重複したらエラーが表示される" do
    2.times do |i|
      click_link "新規登録"
      fill_in "item_master_code", with: item_master[:code]
      fill_in "item_master_name", with: item_master[:name]
      fill_in "item_master_price", with: item_master[:price]
      fill_in "item_master_description", with: item_master[:description]
      click_button "項目を登録する"
    end
    expect(page).to have_content("コードはすでに存在しています。")
  end

  scenario "講座が50個登録できる" do
    1.upto(50){|num|
      click_link "新規登録"
      fill_in "item_master_code", with: num
      fill_in "item_master_name", with: item_master[:name]
      fill_in "item_master_price", with: item_master[:price]
      fill_in "item_master_description", with: item_master[:description]
      click_button "項目を登録する"
      expect(page).to have_content("項目が登録されました。")
    }
  end

  scenario "講座が51個登録はNG" do
    1.upto(50){|num|
      click_link "新規登録"
      fill_in "item_master_code", with: num
      fill_in "item_master_name", with: item_master[:name]
      fill_in "item_master_price", with: item_master[:price]
      fill_in "item_master_description", with: item_master[:description]
      click_button "項目を登録する"
      expect(page).to have_content("項目が登録されました。")
    }
    click_link "新規登録"
    expect(page).to have_content("登録できる項目の上限に達しています。")
    expect(current_path).to eq item_master_index_path
  end

  scenario "項目が削除できる" do
    click_link "新規登録"
    fill_in "item_master_code", with: item_master[:code]
    fill_in "item_master_name", with: item_master[:name]
    fill_in "item_master_price", with: item_master[:price]
    fill_in "item_master_description", with: item_master[:description]
    click_button "項目を登録する"
    click_link "削除"
    expect(page).to have_content("項目が登録されていません。")
  end

end