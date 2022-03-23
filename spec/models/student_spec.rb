require 'rails_helper'

RSpec.describe Student, type: :model do
  describe '生徒登録' do

    let(:current_user) {FactoryBot.build(:user)}
    let(:student) {FactoryBot.build(:student)}

    it "studentが登録できればOK" do
      current_user.students << student
      expect(current_user.students.first).to be_valid
    end

    it "expire_dateが不正ならNG" do
      student.expire_date = "2021-13-20"
      current_user.students << student
      expect(current_user.students.first.expire_date).to be_nil
    end
    
    it "start_dateが不正ならNG" do
      student.start_date = "2021-13-20"
      current_user.students << student
      expect(current_user.students.first.start_date).to be_nil
    end

    it "class_nameが空白ならNG" do
      student.class_name = ""
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end

    it "class_nameが11字以上ならNG" do
      student.class_name = "あいうえおかきくけこあ"
      current_user.students << student
      expect(current_user.students.first).to be_invalid
    end


  end
end
