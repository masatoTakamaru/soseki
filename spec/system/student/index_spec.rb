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
    expect(page).to have_content('30 人')
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

describe "生徒の進級が正しく行える", type: :system do
  let(:current_user) {user_seed}
  let(:item_master) {item_master_seed}
  let(:students) {student_seed}
  let(:item) {item_seed}
  let(:stu) {student_seed.first}

  before do
    visit "users/sign_in"
    fill_in "user_email", with: current_user.email
    fill_in "user_password", with: current_user.password
    find("input[name='commit']").click
    click_link "生徒"
  end

  it "未就学は変更しない" do
    stu[:grade] = 0
    reg_student(stu)
    expect(page).to have_content "未就学"
    click_link "卒・退会者を除く生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    expect(page).to have_content "未就学"
  end

  it "年少から年中へ進級する" do
    stu[:grade] = 1
    reg_student(stu)
    expect(page).to have_content "年少"
    click_link "卒・退会者を除く生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    expect(page).to have_content "年中"
  end

  it "年中から年長へ進級する" do
    stu[:grade] = 2
    reg_student(stu)
    expect(page).to have_content "年中"
    click_link "卒・退会者を除く生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    expect(page).to have_content "年長"
  end

  it "年長から小学１年へ進級する" do
    stu[:grade] = 3
    reg_student(stu)
    expect(page).to have_content "年長"
    click_link "卒・退会者を除く生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    expect(page).to have_content "小学１年"
  end

  it "小学１年から小学２年へ進級する" do
    stu[:grade] = 4
    reg_student(stu)
    expect(page).to have_content "小学１年"
    click_link "卒・退会者を除く生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    expect(page).to have_content "小学２年"
  end

  it "小学２年から小学３年へ進級する" do
    stu[:grade] = 5
    reg_student(stu)
    expect(page).to have_content "小学２年"
    click_link "卒・退会者を除く生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    expect(page).to have_content "小学３年"
  end

  it "小学３年から小学４年へ進級する" do
    stu[:grade] = 6
    reg_student(stu)
    expect(page).to have_content "小学３年"
    click_link "卒・退会者を除く生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    expect(page).to have_content "小学４年"
  end

  it "小学４年から小学５年へ進級する" do
    stu[:grade] = 7
    reg_student(stu)
    expect(page).to have_content "小学４年"
    click_link "卒・退会者を除く生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    expect(page).to have_content "小学５年"
  end

  it "小学５年から小学６年へ進級する" do
    stu[:grade] = 8
    reg_student(stu)
    expect(page).to have_content "小学５年"
    click_link "卒・退会者を除く生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    expect(page).to have_content "小学６年"
  end

  it "小学６年から中学１年へ進級する" do
    stu[:grade] = 9
    reg_student(stu)
    expect(page).to have_content "小学６年"
    click_link "卒・退会者を除く生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    expect(page).to have_content "中学１年"
  end

  it "中学１年から中学２年へ進級する" do
    stu[:grade] = 10
    reg_student(stu)
    expect(page).to have_content "中学１年"
    click_link "卒・退会者を除く生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    expect(page).to have_content "中学２年"
  end

  it "中学２年から中学３年へ進級する" do
    stu[:grade] = 11
    reg_student(stu)
    expect(page).to have_content "中学２年"
    click_link "卒・退会者を除く生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    expect(page).to have_content "中学３年"
  end

  it "中学３年から高校１年へ進級する" do
    stu[:grade] = 12
    reg_student(stu)
    expect(page).to have_content "中学３年"
    click_link "卒・退会者を除く生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    expect(page).to have_content "高校１年"
  end

  it "高校１年から高校２年へ進級する" do
    stu[:grade] = 13
    reg_student(stu)
    expect(page).to have_content "高校１年"
    click_link "卒・退会者を除く生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    expect(page).to have_content "高校２年"
  end

  it "高校２年から高校３年へ進級する" do
    stu[:grade] = 14
    reg_student(stu)
    expect(page).to have_content "高校２年"
    click_link "卒・退会者を除く生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    expect(page).to have_content "高校３年"
  end

  it "高校３年から既卒へ進級する" do
    stu[:grade] = 15
    reg_student(stu)
    expect(page).to have_content "高校３年"
    click_link "卒・退会者を除く生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    expect(page).to have_content "既卒"
  end

  it "既卒は変更しない" do
    stu[:grade] = 16
    reg_student(stu)
    expect(page).to have_content "既卒"
    click_link "卒・退会者を除く生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    expect(page).to have_content "既卒"
  end

end

describe "卒・退会者の進級が正しく行える", type: :system do
  let(:current_user) {user_seed}
  let(:item_master) {item_master_seed}
  let(:students) {student_seed}
  let(:item) {item_seed}
  let(:stu) {student_seed.first}
  let(:stu_second) {student_seed.second}

  before do
    visit "users/sign_in"
    fill_in "user_email", with: current_user.email
    fill_in "user_password", with: current_user.password
    find("input[name='commit']").click
    click_link "生徒"
  end

  it "未就学は変更しない" do
    stu[:grade] = 0
    reg_student(stu)
    reg_student(stu_second)
    expect(page).to have_content "未就学"
    click_link "沼田 寧花"
    click_button "卒・退会"
    click_link "卒・退会者を含むすべての生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    click_link "卒・退会者"
    expect(page).to have_content "未就学"
  end

  it "年少から年中へ進級する" do
    stu[:grade] = 1
    reg_student(stu)
    reg_student(stu_second)
    expect(page).to have_content "未就学"
    click_link "沼田 寧花"
    click_button "卒・退会"
    click_link "卒・退会者を含むすべての生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    click_link "卒・退会者"
    expect(page).to have_content "年中"
  end

  it "年中から年長へ進級する" do
    stu[:grade] = 2
    reg_student(stu)
    reg_student(stu_second)
    expect(page).to have_content "未就学"
    click_link "沼田 寧花"
    click_button "卒・退会"
    click_link "卒・退会者を含むすべての生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    click_link "卒・退会者"
    expect(page).to have_content "年長"
  end

  it "年長から小学１年へ進級する" do
    stu[:grade] = 3
    reg_student(stu)
    reg_student(stu_second)
    expect(page).to have_content "未就学"
    click_link "沼田 寧花"
    click_button "卒・退会"
    click_link "卒・退会者を含むすべての生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    click_link "卒・退会者"
    expect(page).to have_content "小学１年"
  end

  it "小学１年から小学２年へ進級する" do
    stu[:grade] = 4
    reg_student(stu)
    reg_student(stu_second)
    expect(page).to have_content "未就学"
    click_link "沼田 寧花"
    click_button "卒・退会"
    click_link "卒・退会者を含むすべての生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    click_link "卒・退会者"
    expect(page).to have_content "小学２年"
  end

  it "小学２年から小学３年へ進級する" do
    stu[:grade] = 5
    reg_student(stu)
    reg_student(stu_second)
    expect(page).to have_content "未就学"
    click_link "沼田 寧花"
    click_button "卒・退会"
    click_link "卒・退会者を含むすべての生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    click_link "卒・退会者"
    expect(page).to have_content "小学３年"
  end

  it "小学３年から小学４年へ進級する" do
    stu[:grade] = 6
    reg_student(stu)
    reg_student(stu_second)
    expect(page).to have_content "未就学"
    click_link "沼田 寧花"
    click_button "卒・退会"
    click_link "卒・退会者を含むすべての生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    click_link "卒・退会者"
    expect(page).to have_content "小学４年"
  end

  it "小学４年から小学５年へ進級する" do
    stu[:grade] = 7
    reg_student(stu)
    reg_student(stu_second)
    expect(page).to have_content "未就学"
    click_link "沼田 寧花"
    click_button "卒・退会"
    click_link "卒・退会者を含むすべての生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    click_link "卒・退会者"
    expect(page).to have_content "小学５年"
  end

  it "小学５年から小学６年へ進級する" do
    stu[:grade] = 8
    reg_student(stu)
    reg_student(stu_second)
    expect(page).to have_content "未就学"
    click_link "沼田 寧花"
    click_button "卒・退会"
    click_link "卒・退会者を含むすべての生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    click_link "卒・退会者"
    expect(page).to have_content "小学６年"
  end

  it "小学６年から中学１年へ進級する" do
    stu[:grade] = 9
    reg_student(stu)
    reg_student(stu_second)
    expect(page).to have_content "未就学"
    click_link "沼田 寧花"
    click_button "卒・退会"
    click_link "卒・退会者を含むすべての生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    click_link "卒・退会者"
    expect(page).to have_content "中学１年"
  end

  it "中学１年から中学２年へ進級する" do
    stu[:grade] = 10
    reg_student(stu)
    reg_student(stu_second)
    expect(page).to have_content "未就学"
    click_link "沼田 寧花"
    click_button "卒・退会"
    click_link "卒・退会者を含むすべての生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    click_link "卒・退会者"
    expect(page).to have_content "中学２年"
  end

  it "中学２年から中学３年へ進級する" do
    stu[:grade] = 11
    reg_student(stu)
    reg_student(stu_second)
    expect(page).to have_content "未就学"
    click_link "沼田 寧花"
    click_button "卒・退会"
    click_link "卒・退会者を含むすべての生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    click_link "卒・退会者"
    expect(page).to have_content "中学３年"
  end

  it "中学３年から高校１年へ進級する" do
    stu[:grade] = 12
    reg_student(stu)
    reg_student(stu_second)
    expect(page).to have_content "未就学"
    click_link "沼田 寧花"
    click_button "卒・退会"
    click_link "卒・退会者を含むすべての生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    click_link "卒・退会者"
    expect(page).to have_content "高校１年"
  end

  it "高校１年から高校２年へ進級する" do
    stu[:grade] = 13
    reg_student(stu)
    reg_student(stu_second)
    expect(page).to have_content "未就学"
    click_link "沼田 寧花"
    click_button "卒・退会"
    click_link "卒・退会者を含むすべての生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    click_link "卒・退会者"
    expect(page).to have_content "高校２年"
  end

  it "高校２年から高校３年へ進級する" do
    stu[:grade] = 14
    reg_student(stu)
    reg_student(stu_second)
    expect(page).to have_content "未就学"
    click_link "沼田 寧花"
    click_button "卒・退会"
    click_link "卒・退会者を含むすべての生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    click_link "卒・退会者"
    expect(page).to have_content "高校３年"
  end

  it "高校３年から既卒へ進級する" do
    stu[:grade] = 15
    reg_student(stu)
    reg_student(stu_second)
    expect(page).to have_content "未就学"
    click_link "沼田 寧花"
    click_button "卒・退会"
    click_link "卒・退会者を含むすべての生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    click_link "卒・退会者"
    expect(page).to have_content "既卒"
  end

  it "既卒は変更しない" do
    stu[:grade] = 16
    reg_student(stu)
    reg_student(stu_second)
    expect(page).to have_content "未就学"
    click_link "沼田 寧花"
    click_button "卒・退会"
    click_link "卒・退会者を含むすべての生徒を進級"
    expect(page).to have_content "生徒を進級させました。"
    click_link "卒・退会者"
    expect(page).to have_content "既卒"
  end

end