class Item < ApplicationRecord
  include Hashid::Rails
  belongs_to :student

  PRICE_REGEXP = /\A-?\d+.\d+\z/

  validates :period, presence: true
  validates :category, presence: true
  validates :name,
    presence: true,
    length: {maximum: 40}
  validates :price,
    presence: true,
    numericality: true,
    format: {with: PRICE_REGEXP, message: "は正の数か負の数（小数含む）を入力して下さい。"}
  validates :description,
    allow_nil: true,
    length: {maximum: 80}

end
