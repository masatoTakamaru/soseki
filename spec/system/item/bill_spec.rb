require "rails_helper"
describe "帳簿の新規登録", type: :system do
  let!(:current_user) {user_seed}
  let!(:item_masters) {item_master_seed}
  let!(:students) {student_seed}
  let!(:qty_prices) {qty_price_seed}

  before do
    user_login
    reg_student(students.first)
    reg_items_master(item_masters.first)
    reg_qty_price
    click_link "ダッシュボード"
    fill_in "year", with: 2022
    fill_in "month", with: 4
    click_button "新規台帳の作成"
    click_link "沼田 寧花"
  end

  it "従量の価格が正しく登録されている" do
    click_link "講座と費用"
    click_link "設定"
    select "未就学", from: "grade"
    click_button "選択"
    expect(page).to have_field("price1", with: "7900.0")
    expect(page).to have_field("price2", with: "15100.0")
  end

  it "タイトルが正しく表示される" do
    expect(page).to have_title("月謝の登録")
  end

  it "見出しが正しく表示される" do
    expect(page).to have_content("月謝の登録")
  end

  it "項目の検索が表示される" do
    expect(page).to have_content("項目の検索")
    expect(page).to have_content("コードで検索")
  end

  it "登録項目がない場合メッセージが表示される" do
    expect(page).to have_content("項目が登録されていません。")
  end

  it "項目の検索結果が正しく表示される" do
    fill_in "code", with: 1011
    click_button "検索"
    expect(page).to have_content("中１国語")
  end

  it "コードによる検索に該当しないコードを入力するとエラーが表示される" do
    fill_in "code", with: 9000
    click_button "検索"
    expect(page).to have_content("項目が見つかりません。")
  end

  it "追加をクリックすると項目が登録される" do
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    expect(current_user.items.first).not_to eq be_empty
  end

  it "削除をクリックすると項目が削除される" do
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    click_button "削除"
    expect(page).to have_content("項目が登録されていません。")
  end

  it "金額が正しく表示される" do
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    expect(page).to have_content("15,500")
  end

  it "シートの削除ボタンをクリックするとメッセージが表示される" do
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    click_button "戻る"
    click_button "削除"
    expect(page).to have_content("登録項目を削除しました。")
  end

  it "シートの削除ボタンをクリックすると項目が削除される" do
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    click_button "戻る"
    click_button "削除"
    expect(page).not_to have_content("15,500")
  end


end

describe "合計額が正しく表示される", type: :system do

  let(:current_user) {user_seed}
  let(:item_masters) {item_master_seed}
  let(:qty_prices) {qty_price_seed}
  let(:students) {student_seed}

  before do
    user_login
    students.each do |e|
      reg_student(e)
    end
    s1 = current_user.students.find_by(family_name: "沼田", given_name: "寧花")
    sib = s1[:sibling_group]
    s2 = current_user.students.find_by(family_name: "沼田", given_name: "大介")
    s2.update(sibling_group: sib)
    s3 = current_user.students.find_by(family_name: "沼田", given_name: "貴隆")
    s3.update(sibling_group: sib)
    item_masters.each do |e|
      current_user.item_masters << e
    end
    reg_qty_price
    click_link "ダッシュボード"
    expect(page).to have_content("新規台帳の作成")
    fill_in "year", with: 2022
    fill_in "month", with: 4
    click_button "新規台帳の作成"
  end

  it "合計の計算が正しく行われる" do
    click_link "沼田 寧花"
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    expect(page).to have_content("22,200")
    fill_in "code", with: 2001
    click_button "検索"
    click_button "追加"
    expect(page).to have_content("単独")
    expect(page).to have_content("19,800")
    fill_in "code", with: 8001
    click_button "検索"
    click_button "追加"
    expect(page).to have_content("諸費")
    expect(page).to have_content("3,300")
    fill_in "code", with: 9002
    click_button "検索"
    click_button "追加"
    expect(page).to have_content("家族割引")
    expect(page).to have_content("3,000")
    expect(page).to have_content("42,300")
  end

  it "兄弟姉妹計が正しく表示される" do
    click_link "沼田 寧花"
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    click_button "戻る"
    click_link "沼田 大介"
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    click_button "戻る"
    click_link "沼田 貴隆"
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    click_button "戻る"
    expect(page).to have_content("8,200")
    expect(page).to have_content("9,600")
    expect(page).to have_content("10,200")
    expect(page).to have_content("28,000")
  end

  it "兄弟姉妹が退会しても記録が残る" do
    click_link "沼田 寧花"
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    click_button "戻る"
    click_link "沼田 大介"
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    click_button "戻る"
    click_link "沼田 貴隆"
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    click_link "生徒"
    click_link "沼田 貴隆"
    fill_in "student_expire_date", with: "2022-05-01"
    click_button "卒・退会"
    click_link "生徒"
    expect(page).not_to have_content("沼田 貴隆")
    click_link "ダッシュボード"
    click_link "2022 年 4 月"
    expect(page).to have_content("沼田 貴隆")
    expect(page).to have_content("8,200")
    expect(page).to have_content("9,600")
    expect(page).to have_content("10,200")
    expect(page).to have_content("28,000")
  end

  it "項目がない場合小計が表示されない" do
    expect(page).not_to have_content("小計")
  end

  it "兄弟姉妹の1人の項目が存在すれば小計を表示する" do
    click_link "沼田 寧花"
    fill_in "code", with: 1011
    click_button "検索"
    click_button "追加"
    click_button "戻る"
    expect(page).to have_content("小計")
  end

end