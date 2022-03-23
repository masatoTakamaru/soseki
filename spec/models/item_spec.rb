require "rails_helper"

RSpec.describe Item, type: :model do

  context "教科が正しく登録できる" do

    before do
      @current_user = FactoryBot.create(:user)
      student_prototype = FactoryBot.build(:student)
      @current_user.students << student_prototype
      @student = @current_user.students.first
      @item = FactoryBot.build(:item)
    end

    it "台帳月が空白はNG" do
      @item.period = ""
      @student.items << @item
      expect(@student.items.first).to be_invalid
    end

    it "台帳月が不正な日付はNG" do
      @item.period = "2022-01-100"
      @student.items << @item
      expect(@student.items.first.period).to be_nil
    end

    it "所属クラスが空白はNG" do
      @item.class_name = ""
      @student.items << @item
      expect(@student.items.first).to be_invalid
    end

    it "所属クラスが11字以上はNG" do
      @item.class_name = "１２３４５６７８９０１"
      @student.items << @item
      expect(@student.items.first).to be_invalid
    end

    it "カテゴリが空白はNG" do
      @item.category = ""
      @student.items << @item
      expect(@student.items.first).to be_invalid
    end

    it "教科名が空白はNG" do
      @item.name = ""
      @student.items << @item
      expect(@student.items.first).to be_invalid
    end

    it "教科名が21字以上はNG" do
      @item.name = "１２３４５６７８９０１２３４５６７８９０１"
      @student.items << @item
      expect(@student.items.first).to be_invalid
    end

    it "価格が空白はNG" do
      @item.price = ""
      @student.items << @item
      expect(@student.items.first).to be_invalid
    end

    it "価格が負の値はOK" do
      @item.price = "-1.5"
      @student.items << @item
      expect(@student.items.first).to be_valid
    end

    it "価格が数式はNG" do
      @item.price = "1+2"
      @student.items << @item
      expect(@student.items.first).to be_invalid
    end

    it "価格が全角文字はNG" do
      @item.price = "１２３"
      @student.items << @item
      expect(@student.items.first).to be_invalid
    end
  end

  context "テーブル関連付けが正しく動作する" do

    before do
      @current_user = FactoryBot.create(:user)
      student_prototype = FactoryBot.build(:student)
      @current_user.students << student_prototype
      @student = @current_user.students.first
      @item = FactoryBot.build(:item)
    end

    it "教科が登録できる" do
      @student.items << @item
      expect(@student.items.first).to be_valid
    end

    it "教科が削除できる" do
      @student.items << @item
      item = @student.items.first
      item.destroy
      expect(@student.items.first).to be_nil
    end

    it "生徒を削除すると教科も削除される" do
      @student.items << @item
      id = @item.id
      @student.destroy
      expect(Item.find_by(id: id)).to be_nil
    end

    it "ユーザーを削除すると教科も削除される" do
      @student.items << @item
      id = @item.id
      @current_user.destroy
      expect(Item.find_by(id: id)).to be_nil
    end

  end

end
