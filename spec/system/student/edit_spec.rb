require 'rails_helper'

describe "生徒の編集", type: :system do
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
    click_link "生徒"
    click_link "沼田 寧花"
    click_link "生徒の編集"
  end

  it "入会日が変更できる" do
    fill_in "student_start_date", with: "2022-10-01"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "入会日が存在しない日付の場合エラーが表示される" do
    fill_in "student_start_date", with: "2022-13-01"
    click_button "更新"
    expect(page).to have_content("入会日に誤りがあります。正しい日付を入力して下さい。")
  end

  it "生徒姓が変更できる" do
    fill_in "student_family_name", with: "佐藤"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "生徒姓が空白はNG" do
    fill_in "student_family_name", with: ""
    click_button "更新"
    expect(page).to have_content("生徒の姓を入力してください")
  end

  it "生徒姓に記号が含まれる場合エラーが表示される" do
    fill_in "student_family_name", with: "佐藤@"
    click_button "更新"
    expect(page).to have_content("生徒の姓は漢字、ひらがな、カタカナ、アルファベットのいずれかを入力して下さい。")
  end

  it "生徒名が変更できる" do
    fill_in "student_given_name", with: "次郎"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "生徒名が空白はNG" do
    fill_in "student_given_name", with: ""
    click_button "更新"
    expect(page).to have_content("生徒の名を入力してください")
  end

  it "生徒名に記号が含まれる場合エラーが表示される" do
    fill_in "student_given_name", with: "佐藤￥"
    click_button "更新"
    expect(page).to have_content("生徒の名は漢字、ひらがな、カタカナ、アルファベットのいずれかを入力して下さい。")
  end

  it "生徒姓カナが変更できる" do
    fill_in "student_family_name_kana", with: "サトウ"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "生徒姓カナが空白はNG" do
    fill_in "student_family_name_kana", with: ""
    click_button "更新"
    expect(page).to have_content("生徒の姓のフリガナを入力してください")
  end

  it "生徒姓カナに記号を含む場合エラーが表示される" do
    fill_in "student_family_name_kana", with: "サトウ["
    click_button "更新"
    expect(page).to have_content("生徒の姓のフリガナは全角カタカナで入力して下さい。")
  end

  it "生徒姓カナが半角カタカナの場合エラーが表示される" do
    fill_in "student_family_name_kana", with: "ｻﾄｳ"
    click_button "更新"
    expect(page).to have_content("生徒の姓のフリガナは全角カタカナで入力して下さい。")
  end

  it "生徒姓カナがひらがなの場合エラーが表示される" do
    fill_in "student_family_name_kana", with: "さとう"
    click_button "更新"
    expect(page).to have_content("生徒の姓のフリガナは全角カタカナで入力して下さい。")
  end

  it "生徒名カナが変更できる" do
    fill_in "student_given_name_kana", with: "ジロウ"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "生徒名カナが空白はNG" do
    fill_in "student_given_name_kana", with: ""
    click_button "更新"
    expect(page).to have_content("生徒の名のフリガナを入力してください")
  end

  it "生徒名カナに記号が含まれる場合エラーが表示される" do
    fill_in "student_given_name_kana", with: "ジロウ＠"
    click_button "更新"
    expect(page).to have_content("生徒の名のフリガナは全角カタカナで入力して下さい。")
  end

  it "生徒名カナが半角カタカナの場合エラーが表示される" do
    fill_in "student_given_name_kana", with: "ｼﾞﾛｳ"
    click_button "更新"
    expect(page).to have_content("生徒の名のフリガナは全角カタカナで入力して下さい。")
  end

  it "生徒名カナがひらがなの場合エラーが表示される" do
    fill_in "student_given_name_kana", with: "じろう"
    click_button "更新"
    expect(page).to have_content("生徒の名のフリガナは全角カタカナで入力して下さい。")
  end

  it "性別が未選択はNG" do
    select "選択して下さい。", from: "student_gender"
    click_button "更新"
    expect(page).to have_content("性別を入力してください")
  end

  it "性別　男が選択できる" do
    select "男", from: "student_gender"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "性別　女が選択できる" do
    select "女", from: "student_gender"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "性別　その他が選択できる" do
    select "その他", from: "student_gender"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "生年月日が変更できる" do
    fill_in "student_birth_date", with: "2008-5-11"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "生年月日が空白はOK" do
    fill_in "student_birth_date", with: ""
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "学校名が変更できる" do
    fill_in "student_school_belong_to", with: "桜丘中"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "学校名が空白はOK" do
    fill_in "student_school_belong_to", with: ""
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "学校名が41字以上はNG" do
    fill_in "student_school_belong_to", with: "学校名は40文字以内で入力してください"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "保護者姓が変更できる" do
    fill_in "student_guardian_family_name", with: "サトウ"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "保護者姓が空白はOK" do
    fill_in "student_guardian_family_name", with: ""
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "保護者名が変更できる" do
    fill_in "student_guardian_given_name", with: "次郎"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "保護者名が空白はOK" do
    fill_in "student_guardian_given_name", with: ""
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "保護者姓カナが変更できる" do
    fill_in "student_guardian_family_name_kana", with: "サトウ"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "保護者姓カナが空白はOK" do
    fill_in "student_guardian_family_name_kana", with: ""
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "保護者名カナが変更できる" do
    fill_in "student_guardian_given_name_kana", with: "ジロウ"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "保護者名カナが空白はOK" do
    fill_in "student_guardian_given_name_kana", with: ""
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "電話番号１が変更できる" do
    fill_in "student_phone1", with: "092-123-4567"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "電話番号１がハイフンなしはNG" do
    fill_in "student_phone1", with: "0921234567"
    click_button "更新"
    expect(page).to have_content("電話番号１に誤りがあります。")
  end

  it "電話番号１が全角はNG" do
    fill_in "student_phone1", with: "０９０－１２３４－５６７８"
    click_button "更新"
    expect(page).to have_content("電話番号１に誤りがあります。")
  end

  it "電話番号１が数字以外はNG" do
    fill_in "student_phone1", with: "あ"
    click_button "更新"
    expect(page).to have_content("電話番号１に誤りがあります。")
  end

  it "電話番号１の続柄が変更できる" do
    fill_in "student_phone1_belong_to", with: "本人"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "電話番号１の続柄が空白はOK" do
    fill_in "student_phone1_belong_to", with: ""
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "電話番号１の続柄が11字以上はNG" do
    fill_in "student_phone1_belong_to", with: "１２３４５６７８９０１"
    click_button "更新"
    expect(page).to have_content("電話番号１の続柄は10文字以内で入力してください")
  end

  it "電話番号２が変更できる" do
    fill_in "student_phone2", with: "080-1234-5678"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "電話番号２がハイフンなしはNG" do
    fill_in "student_phone2", with: "0921234567"
    click_button "更新"
    expect(page).to have_content("電話番号２に誤りがあります。")
  end

  it "電話番号２が全角はNG" do
    fill_in "student_phone2", with: "０９０－１２３４－５６７８"
    click_button "更新"
    expect(page).to have_content("電話番号２に誤りがあります。")
  end

  it "電話番号２が数字以外はNG" do
    fill_in "student_phone2", with: "あ"
    click_button "更新"
    expect(page).to have_content("電話番号２に誤りがあります。")
  end

  it "電話番号２の続柄が変更できる" do
    fill_in "student_phone2_belong_to", with: "母"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "電話番号２の続柄が空白はOK" do
    fill_in "student_phone2_belong_to", with: ""
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "電話番号２の続柄が11字以上はNG" do
    fill_in "student_phone2_belong_to", with: "１２３４５６７８９０１"
    click_button "更新"
    expect(page).to have_content("電話番号２の続柄は10文字以内で入力してください")
  end

  it "メールアドレスが変更できる" do
    fill_in "student_email", with: "a@gmail.com"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "メールアドレスが空白はOK" do
    fill_in "student_email", with: ""
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "メールアドレスの＠抜けはNG" do
    fill_in "student_email", with: "gmail.com"
    click_button "更新"
    expect(page).to have_content("メールアドレスに誤りがあります。")
  end

  it "メールアドレスが全角はNG" do
    fill_in "student_email", with: "ｔｅｓｔ＠ｇｍａｉｌ．ｃｏｍ"
    click_button "更新"
    expect(page).to have_content("メールアドレスに誤りがあります。")
  end

  it "備考欄が変更できる" do
    fill_in "student_remarks", with: "test"
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "備考欄が空白はOK" do
    fill_in "student_remarks", with: ""
    click_button "更新"
    expect(page).to have_content("生徒情報が更新されました。")
  end

  it "備考欄が241字以上はNG" do
    fill_in "student_remarks", with: "１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１"
    click_button "更新"
    expect(page).to have_content("備考欄は240文字以内で入力してください")
  end

  it "キャンセルできる" do
    click_link "キャンセル"
    expect(page).to have_content("生徒の情報")
  end

end