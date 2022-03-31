class ItemMaster < ApplicationRecord
  include Hashid::Rails

  belongs_to :user
  PRICE_REGEXP = /\A-?\d+.\d+\z/

  validates :code,
    presence: true,
    numericality: {
          only_integer: true,
          greater_than: 0,
          less_than: 10000,
          message: "は0から9999までの間で入力して下さい。"}
  validates :category,
    presence: true,
    numericality: {
          only_integer: true,
          greater_than: 0,
          less_than: 3,
          message: "は0から3までの間で入力して下さい。"}
  validates :name,
    presence: true,
    length: {maximum: 20}
  validates :price,
    presence: true,
    numericality: true,
    format: {with: PRICE_REGEXP, message: "は正の数か負の数（小数含む）を入力して下さい。"}
  validates :description,
    allow_nil: true,
    length: {maximum: 40}

end
