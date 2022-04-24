class ItemMaster < ApplicationRecord
  include Hashid::Rails

  belongs_to :user

  validates :code,
    presence: true,
    uniqueness: {message:"はすでに存在しています。"},
    numericality: {
          only_integer: true,
          greater_than_or_equal_to: 1,
          less_than_or_equal_to: 9999,
          message: "は0から9999までの間で入力して下さい。"}
  validates :category,
    presence: true,
    numericality: {
          only_integer: true,
          greater_than_or_equal_to: 0,
          less_than_or_equal_to: 4,
          message: "は0から3までの間で入力して下さい。"}
  validates :name,
    presence: true,
    length: {maximum: 30}
  validates :price,
    presence: true,
    numericality: {
      greater_than_or_equal_to: 0,
      message: "は正の数を入力して下さい。"}
  validates :description,
    allow_nil: true,
    length: {maximum: 40}
end
