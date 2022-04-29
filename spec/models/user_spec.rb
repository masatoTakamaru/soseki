require 'rails_helper'

describe User, type: :model do
  context 'ユーザー登録' do

    let(:user) {user_seed}

    it "ユーザーが登録できればOK" do
      expect(user).to be_valid
    end
    it "usenameが空白ならNG" do
      user.username = ""
      expect(user).to be_invalid
    end
    it "usenameが21字以上ならNG" do
      user.username = "あいうえおかきくけこあいうえおかきくけこあ"
      expect(user).to be_invalid
    end
    it "emailが空白ならNG" do
      user.email = ""
      expect(user).to be_invalid
    end
    it "emailが不正ならNG" do
      user.email = "examplegmail.com"
      expect(user).to be_invalid
    end
    it "emailが不正ならNG" do
      user.email = "example@@gmail.com"
      expect(user).to be_invalid
    end
    it "passwordが6字未満ならNG" do
      user.password = "12345"
      expect(user).to be_invalid
    end
    it "passwordが不正ならNG" do
      user.password = "あいう"
      expect(user).to be_invalid
    end
    it "password_confirmationが6字未満ならNG" do
      user.password_confirmation = "12345"
      expect(user).to be_invalid
    end
    it "passwordが不正ならNG" do
      user.password_confirmation = "あいう"
      expect(user).to be_invalid
    end










  end
end
