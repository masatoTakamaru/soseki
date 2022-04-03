require 'rails_helper'
require "spec_helper"

feature "講座管理", type: :feature do

  before do
    user_seed
    students_seed
    visit "users/sign_in"
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    find('input[name="commit"]').click
    click_link "講座"
  end

  scenario "タイトルが正しく表示される" do
    expect(page).to have_title("講座管理")
  end

  scenario "見出しが正しく表示される" do
    expect(page).to have_content("講座管理")
  end

  scenario "講座未登録の場合メッセージが表示される" do
    expect(page).to have_content("講座が登録されていません。")
  end

  scenario "新規登録ボタンを押して登録画面に移動できる" do
    click_link "新規登録"
    expect(page).to have_content("講座の新規登録")
  end

  scenario "新規登録のタイトルが正しく表示される" do
    click_link "新規登録"
    expect(page).to have_title("講座の新規登録")
  end

  scenario "講座が登録できる" do
    item_master_seed
    item_master = @item_masters.first
    click_link "新規登録"
    fill_in "item_master_code", with: item_master.code
    fill_in "item_master_category", with: item_master.category
    fill_in "item_master_name", with: item_master.name
    fill_in "item_master_price", with: item_master.price
    fill_in "item_master_description", with: item_master.description
    click_button "講座を登録する"
    expect(page).to have_content("新規講座が登録されました。")
  end

  scenario "講座が50個登録できる" do
    item_master_seed
    item_master = @item_masters.first
    50.times do |i|
      click_link "新規登録"
      fill_in "item_master_code", with: item_master.code
      fill_in "item_master_category", with: item_master.category
      fill_in "item_master_name", with: item_master.name
      fill_in "item_master_price", with: item_master.price
      fill_in "item_master_description", with: item_master.description
      click_button "講座を登録する"
      expect(page).to have_content("新規講座が登録されました。")
    end
  end

  scenario "講座が51個登録はNG" do
    item_master_seed
    item_master = @item_masters.first
    50.times do |i|
      click_link "新規登録"
      fill_in "item_master_code", with: item_master.code
      fill_in "item_master_category", with: item_master.category
      fill_in "item_master_name", with: item_master.name
      fill_in "item_master_price", with: item_master.price
      fill_in "item_master_description", with: item_master.description
      click_button "講座を登録する"
    end
    click_link "新規登録"
    expect(page).to have_content("登録できる講座の上限に達しています。")
    expect(current_path).to eq item_master_index_path
  end

  scenario "講座が削除できる" do
    item_master_seed
    item_master = @item_masters.first
    click_link "新規登録"
    fill_in "item_master_code", with: item_master.code
    fill_in "item_master_category", with: item_master.category
    fill_in "item_master_name", with: item_master.name
    fill_in "item_master_price", with: item_master.price
    fill_in "item_master_description", with: item_master.description
    click_button "講座を登録する"
    click_link "削除"
    expect(page).to have_content("講座が登録されていません。")
  end

end