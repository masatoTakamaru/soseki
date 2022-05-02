require "rails_helper"
describe "台帳の新規台帳の作成", type: :system do

  let(:current_user) {user_seed}
  let(:item_master) {item_master_seed}
  let(:stus) {student_seed}
  let(:item) {item_seed}
  let(:stu) {student_seed.first}

  before do
    user_login
    reg_student(stu)
    current_user.item_masters << item_master.first
    click_link "ダッシュボード"
    fill_in "year", with: 2022
    fill_in "month", with: 4
    click_button "新規台帳の作成"
  end

  it "タイトルが正しく表示される" do
    expect(page).to have_title("台帳")
  end

  it "見出しが正しく表示される" do
    expect(page).to have_content("台帳")
    expect(page).to have_content("2022 年 4 月")
  end

  it "生徒数が表示される" do
    expect(page).to have_content("生徒数")
    expect(page).to have_content("1人")
  end

  it "リストの並べ替えが表示されない" do
    expect(page).not_to have_content("並べ替え")
  end

  it "生徒名が表示される" do
    expect(page).to have_content("沼田 寧花")
  end
  
  it "戻るをクリックするとダッシュボードに戻る" do
    click_link "戻る"
    expect(current_path).to eq dashboard_path
  end
end

describe "入会日によって生徒の表示・非表示が変わる", type: :system do

  let(:current_user) {user_seed}
  let(:item_masters) {item_master_seed}
  let(:stus) {student_seed}
  let(:item) {item_seed}
  let(:stu_init) {student_seed.second}
  let(:stu) {student_seed.first}

  before do
    user_login
    reg_student(stu_init)
    item_masters.each do |e|
      current_user.item_masters << e
    end
    click_link "ダッシュボード"
    fill_in "year", with: 2022
    fill_in "month", with: 4
    click_button "新規台帳の作成"
    expect(page).to have_content("滝田 柚海子")
    click_link "滝田 柚海子"
    fill_in "code", with: 2001
    click_button "検索"
    click_button "追加"
  end

  it "台帳月22-04かつ入会日22-04-01の生徒は表示される" do
    stu[:start_date] = Date.new(2022,4,1)
    reg_student(stu)
    click_link "ダッシュボード"
    click_link "2022 年 4 月"
    expect(page).to have_content("沼田 寧花")
  end

  it "台帳月22-04かつ入会日22-03-31の生徒は表示される" do
    stu[:start_date] = Date.new(2022,3,31)
    reg_student(stu)
    click_link "ダッシュボード"
    click_link "2022 年 4 月"
    expect(page).to have_content("沼田 寧花")
  end

  it "台帳月22-04かつ入会日22-04-30の生徒は表示される" do
    stu[:start_date] = Date.new(2022,4,30)
    reg_student(stu)
    click_link "ダッシュボード"
    click_link "2022 年 4 月"
    expect(page).to have_content("沼田 寧花")
  end

  it "台帳月22-04かつ入会日22-05-01の生徒は表示されない" do
    stu[:start_date] = Date.new(2022,5,1)
    reg_student(stu)
    click_link "ダッシュボード"
    click_link "2022 年 4 月"
    expect(page).not_to have_content("沼田 寧花")
  end
end

describe "退会日によって生徒の表示・非表示が変わる", type: :system do

  let(:current_user) {user_seed}
  let(:item_masters) {item_master_seed}
  let(:stus) {student_seed}
  let(:item) {item_seed}
  let(:stu_init) {student_seed.second}
  let(:stu) {student_seed.first}

  before do
    user_login
    reg_student(stu_init)
    item_masters.each do |e|
      current_user.item_masters << e
    end
    click_link "ダッシュボード"
    fill_in "year", with: 2022
    fill_in "month", with: 4
    click_button "新規台帳の作成"
    expect(page).to have_content("滝田 柚海子")
    click_link "滝田 柚海子"
    fill_in "code", with: 2001
    click_button "検索"
    click_button "追加"
  end

  it "台帳月22-04かつ入会日22-04-01退会日22-04-02の生徒は表示される" do
    stu[:start_date] = Date.new(2022,4,1)
    stu[:expire_date] = Date.new(2022,4,2)
    stu[:expire_flag] = true
    current_user.students << stu
    click_link "ダッシュボード"
    click_link "2022 年 4 月"
    expect(page).to have_content("沼田 寧花")
  end

  it "台帳月22-04かつ入会日22-04-01退会日22-05-01の生徒は表示される" do
    stu[:start_date] = Date.new(2022,4,1)
    stu[:expire_date] = Date.new(2022,5,1)
    stu[:expire_flag] = true
    current_user.students << stu
    click_link "ダッシュボード"
    click_link "2022 年 4 月"
    expect(page).to have_content("沼田 寧花")
  end

  it "台帳月22-04かつ入会日22-03-31退会日22-04-01の生徒は表示される" do
    stu[:start_date] = Date.new(2022,3,31)
    stu[:expire_date] = Date.new(2022,4,1)
    stu[:expire_flag] = true
    current_user.students << stu
    click_link "ダッシュボード"
    click_link "2022 年 4 月"
    expect(page).to have_content("沼田 寧花")
  end

  it "台帳月22-04かつ入会日22-03-31退会日22-05-01の生徒は表示される" do
    stu[:start_date] = Date.new(2022,3,31)
    stu[:expire_date] = Date.new(2022,5,1)
    stu[:expire_flag] = true
    current_user.students << stu
    click_link "ダッシュボード"
    click_link "2022 年 4 月"
    expect(page).to have_content("沼田 寧花")
  end

  it "台帳月22-04かつ入会日21-02-28退会日22-03-31の生徒は表示されない" do
    stu[:start_date] = Date.new(2021,2,28)
    stu[:expire_date] = Date.new(2022,3,31)
    stu[:expire_flag] = true
    current_user.students << stu
    click_link "ダッシュボード"
    click_link "2022 年 4 月"
    expect(page).not_to have_content("沼田 寧花")
  end

  it "台帳月22-04かつ入会日22-05-01退会日23-05-31の生徒は表示されない" do
    stu[:start_date] = Date.new(2022,5,1)
    stu[:expire_date] = Date.new(2023,5,31)
    stu[:expire_flag] = true
    current_user.students << stu
    click_link "ダッシュボード"
    click_link "2022 年 4 月"
    expect(page).not_to have_content("沼田 寧花")
  end

end

describe "台帳の複写機能", type: :system do

  let(:current_user) {user_seed}
  let(:item_masters) {item_master_seed}
  let(:stus) {student_seed}
  let(:item) {item_seed}

  before do
    user_login
    stus.each do |e|
      current_user.students << e
    end
    item_masters.each do |e|
      current_user.item_masters << e
    end
    click_link "ダッシュボード"
    fill_in "year", with: 2022
    fill_in "month", with: 4
    click_button "新規台帳の作成"
    click_link "沼田 寧花"
    fill_in "code", with: 2001
    click_button "検索"
    click_button "追加"
    click_button "戻る"
    click_link "戻る"
    expect(page).to have_content("2022 年 4 月")
  end

  it "台帳の複写ができる" do
    expect(page).to have_content("2022 年 4 月の台帳を引き継いで 2022 年 5 月の台帳を作成する。")
    click_button "作成"
    expect(page).to have_content("新規台帳を作成しました。")
    expect(page).to have_content("2022 年 5 月")
    expect(page).to have_content("2022 年 5 月の台帳を引き継いで 2022 年 6 月の台帳を作成する。")
  end

end