require 'rails_helper'

RSpec.describe ItemMaster, type: :model do
  context "教科マスターが正しく登録できる" do

    before do
      @item_master = FactoryBot.build(:item_master)
    end

    it "教科マスターが登録できる" do
      expect(@item_master).to be_valid
    end

    it "所属クラスが空白はNG" do
      @item_master.class_name = ""
      expect(@item_master).to be_invalid
    end

    it "所属クラスが11字以上はNG" do
      @item_master.class_name = "１２３４５６７８９０１"
      expect(@item_master).to be_invalid
    end

    it "カテゴリが空白はNG" do
      @item_master.category = ""
      expect(@item_master).to be_invalid
    end

    it "教科名が空白はNG" do
      @item_master.name = ""
      expect(@item_master).to be_invalid
    end

    it "教科名が21字以上はNG" do
      @item_master.name = "１２３４５６７８９０１２３４５６７８９０１"
      expect(@item_master).to be_invalid
    end

    it "価格が空白はNG" do
      @item_master.price = ""
      expect(@item_master).to be_invalid
    end

    it "価格が負の値はOK" do
      @item_master.price = "-1.5"
      expect(@item_master).to be_valid
    end

    it "価格が数式はNG" do
      @item_master.price = "1+2"
      expect(@item_master).to be_invalid
    end

    it "価格が全角文字はNG" do
      @item_master.price = "１２３"
      expect(@item_master).to be_invalid
    end

  end
end