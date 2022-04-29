require 'rails_helper'

describe "生徒の登録", type: :system do
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
    click_link "生徒"
  end

  it "生徒の新規登録ができる" do
    expect(page).to have_content('生徒は登録されていません。')
    expect(page).to have_content('新規登録')
    reg_student(student)
    expect(page).to have_content('生徒数')
    expect(page).to have_content('沼田')
  end

  it "生徒を30人まで登録できる" do
    30.times do |i|
      reg_student(student)
    end
    expect(page).to have_content('30人')
  end

  it "生徒を31人登録はNG" do
    30.times do |i|
      reg_student(student)
    end
    click_link "新規登録"
    expect(page).to have_content('登録できる生徒の上限に達しています。')
    expect(current_path).to eq student_index_path
  end

  it "卒・退会者名簿に移動できる" do
    reg_student(student)
    click_link "卒・退会者"
    expect(current_path).to eq student_expired_path
  end

  it "卒・退会者名簿から生徒一覧に戻れる" do
    reg_student(student)
    click_link "卒・退会者"
    click_link "戻る"
    expect(current_path).to eq student_index_path
  end

end