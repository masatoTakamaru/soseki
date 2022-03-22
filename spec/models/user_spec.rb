require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー登録' do
    it "ユーザーが登録できればOK" do
      user = build(:user)
      expect(user).to be_valid
    end
    it "usenameが空白ならNG" do
      user = build(:user)
      expect(user).to be_valid
    end

    









  end
end
