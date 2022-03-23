require "rails_helper"

RSpec.describe Student, type: :model do

  context "生徒登録のvalidationが正しく機能しているか" do

    let(:current_user) {FactoryBot.build(:user)}
    let(:student) {FactoryBot.build(:student)}

    it "退会日が不正な日付はNG" do
      student.expire_date = "2021-13-20"
      current_user.students << student
      expect(current_user.students.first.expire_date).to be_nil
    end
    
    it "開始日が不正な日付はNG" do
      student.start_date = "2021-13-20"
      current_user.students << student
      expect(current_user.students.first.start_date).to be_nil
    end

    it "所属クラスが空白はNG" do
      student.class_name = ""
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "所属クラスが11字以上はNG" do
      student.class_name = "あいうえおかきくけこあ"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "生徒性が空白はNG" do
      student.family_name = ""
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "生徒性が21字以上はNG" do
      student.family_name = "あいうえおかきくけこあいうえおかきくけこあ"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end
    
    it "生徒性が漢字ひらがなカタカナアルファベット以外はNG" do
      student.family_name = "tanaka@tanaka"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "生徒名が空白はNG" do
      student.given_name = ""
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "生徒名が21字以上はNG" do
      student.given_name = "あいうえおかきくけこあいうえおかきくけこあ"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end
    
    it "生徒名が漢字ひらがなカタカナアルファベット以外はNG" do
      student.given_name = "tanaka@tanaka"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "生徒性カナが空白はNG" do
      student.family_name_kana = ""
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "生徒性カナが21字以上はNG" do
      student.family_name_kana = "あいうえおかきくけこあいうえおかきくけこあ"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end
    
    it "生徒性カナが全角カタカナ以外はNG" do
      student.family_name_kana = "ｱｲｳｴｵ"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "生徒性カナが全角カタカナ以外はNG" do
      student.family_name_kana = "あいうえお"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "生徒名カナが空白はNG" do
      student.given_name_kana = ""
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "生徒名カナが21字以上はNG" do
      student.given_name_kana = "あいうえおかきくけこあいうえおかきくけこあ"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end
    
    it "生徒名カナがカタカナ以外はNG" do
      student.given_name_kana = "ｱｲｳｴｵ"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "生徒名カナがカタカナ以外はNG" do
      student.given_name_kana = "あいうえお"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "保護者性が空白はNG" do
      student.guardian_family_name = ""
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "保護者性が21字以上はNG" do
      student.guardian_family_name = "あいうえおかきくけこあいうえおかきくけこあ"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end
    
    it "保護者性が漢字ひらがなカタカナアルファベット以外はNG" do
      student.guardian_family_name = "tanaka@tanaka"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "保護者名が空白はNG" do
      student.guardian_given_name = ""
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "保護者名が21字以上はNG" do
      student.guardian_given_name = "あいうえおかきくけこあいうえおかきくけこあ"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end
    
    it "保護者名が漢字ひらがなカタカナアルファベット以外はNG" do
      student.guardian_given_name = "tanaka@tanaka"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "保護者性カナが空白はNG" do
      student.guardian_family_name_kana = ""
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "保護者性カナが21字以上はNG" do
      student.guardian_family_name_kana = "あいうえおかきくけこあいうえおかきくけこあ"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end
    
    it "保護者性カナが全角カタカナ以外はNG" do
      student.guardian_family_name_kana = "ｱｲｳｴｵ"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "保護者性カナが全角カタカナ以外はNG" do
      student.guardian_family_name_kana = "あいうえお"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "保護者名カナが空白はNG" do
      student.guardian_given_name_kana = ""
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "保護者名カナが21字以上はNG" do
      student.guardian_given_name_kana = "あいうえおかきくけこあいうえおかきくけこあ"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end
    
    it "保護者名カナがカタカナ以外はNG" do
      student.guardian_given_name_kana = "ｱｲｳｴｵ"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "保護者名カナがカタカナ以外はNG" do
      student.guardian_given_name_kana = "あいうえお"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "生年月日が不正な日付はNG" do
      student.birth_date = "2021-13-20"
      current_user.students << student
      expect(current_user.students.first.birth_date).to be_nil
    end

    it "学校名が空白はOK" do
      student.school_belong_to = ""
      current_user.students << student
      expect(current_user.students.first).to be_valid
    end

    it "学校名が40字以上はNG" do
      student.school_belong_to = "あいうえおかきくけこあいうえおかきくけこあいうえおかきくけこあいうえおかきくけこあ"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "学年が空白はNG" do
      student.grade = ""
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "電話番号１が空白はNG" do
      student.phone1 = ""
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "電話番号１が全角文字はNG" do
      student.phone1 = "１１１－１１１１－１１１１"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "電話番号１がハイフン無しはNG" do
      student.phone1 = "1112223333"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "電話番号１がハイフン3個以上はNG" do
      student.phone1 = "11-111-1111-1111"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "電話番号１がハイフン1個はNG" do
      student.phone1 = "11-1111"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "電話番号１が数字以外はNG" do
      student.phone1 = "111@111"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "電話番号１続柄が空白はOK" do
      student.phone1_belong_to = ""
      current_user.students << student
      expect(current_user.students.first).to be_valid
    end

    it "電話番号１続柄が11字以上はNG" do
      student.phone1 = "あいうえおかきくけこあ"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "電話番号２が空白はOK" do
      student.phone2 = ""
      current_user.students << student
      expect(current_user.students.first).to be_valid
    end

    it "電話番号２が全角文字はNG" do
      student.phone2 = "１１１－１１１１－１１１１"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "電話番号２がハイフン無しはNG" do
      student.phone2 = "1112223333"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "電話番号２がハイフン3個以上はNG" do
      student.phone2 = "11-111-1111-1111"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "電話番号２がハイフン1個はNG" do
      student.phone2 = "11-1111"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "電話番号２が数字以外はNG" do
      student.phone2 = "111@111"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "電話番号２続柄が空白はOK" do
      student.phone2_belong_to = ""
      current_user.students << student
      expect(current_user.students.first).to be_valid
    end

    it "電話番号２続柄が11字以上はNG" do
      student.phone2 = "あいうえおかきくけこあ"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "郵便番号がハイフン入りはNG" do
      student.postal_code = "111-1111"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "郵便番号が空白はNG" do
      student.postal_code = ""
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "郵便番号が7字未満はNG" do
      student.postal_code = "123456"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "郵便番号が8字以上はNG" do
      student.postal_code = "12345678"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "郵便番号が全角文字はNG" do
      student.postal_code = "１２３４５６７"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "郵便番号が記号文字はNG" do
      student.postal_code = "123+4567"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "住所が空白はNG" do
      student.address = ""
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "住所が41字以上はNG" do
      student.address = "１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "メールアドレスが空白はOK" do
      student.email = ""
      current_user.students << student
      expect(current_user.students.first).to be_valid
    end

    it "メールアドレスが73字以上はNG" do
      student.email = "1234567890123456789012345678901234567890123456789012345678901234567890123"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "メールアドレスが@無しはNG" do
      student.email = "sample.com"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "メールアドレスが@2個はNG" do
      student.email = "sample@@gmail.com"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "メールアドレスがコンマ無しはNG" do
      student.email = "samplecom"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "ユーザー名が空白はOK" do
      student.user_name = ""
      current_user.students << student
      expect(current_user.students.first).to be_valid
    end

    it "ユーザー名が21字以上はNG" do
      student.user_name = "123456789012345678901"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "ユーザー名が全角文字はNG" do
      student.user_name = "１１１"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "パスワードが空白はOK" do
      student.password = ""
      current_user.students << student
      expect(current_user.students.first).to be_valid
    end

    it "パスワードが41字以上はNG" do
      student.password = "12345678901234567890123456789012345678901"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "パスワードが全角文字はNG" do
      student.password = "１１１"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "備考欄が空白はOK" do
      student.remarks = ""
      current_user.students << student
      expect(current_user.students.first).to be_valid
    end

    it "備考欄が241字以上はNG" do
      student.remarks = "１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end
  end

  context "ユーザーとの関連付けが正しく機能しているか" do

    let(:current_user) {FactoryBot.create(:user)}
    let(:student) {FactoryBot.build(:student)}

    it "生徒が登録できればOK" do
      current_user.students << student
      expect(current_user.students.first.present?).to be_truthy
    end

    it "生徒が削除できればOK" do
      current_user.students << student
      student = current_user.students.first
      student.destroy
      expect(current_user.students.first).to be_nil
    end

    it "ユーザーを削除したら生徒も削除される" do
      current_user.students << student
      current_user.destroy
      expect(current_user.students.first).to be_nil
    end

  end

end
