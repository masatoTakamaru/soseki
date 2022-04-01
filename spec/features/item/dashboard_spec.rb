require "rails_helper"
feature "ダッシュボード", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:student) { FactoryBot.build(:student) }
  let(:item_master) { FactoryBot.build(:item_master) }

  before do
    visit root_path
    click_link "ログイン"
    fill_in "user_email", with: "2@gmail.com"
    fill_in "user_password", with: "222222"
    click_button "ログイン"
    click_link "ダッシュボード"
  end

  scenario "タイトルが正しく表示される" do
    expect(page).to have_title('ダッシュボード')
  end
end