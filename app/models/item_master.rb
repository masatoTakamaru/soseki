class ItemMaster < ApplicationRecord

  belongs_to :user
  PRICE_REGEXP = /\A-?\d+.\d+\z/

  validates :class_name,
    presence: true,
    length: {maximum: 10}
  validates :category, presence: true
  validates :name,
    presence: true,
    length: {maximum: 20}
  validates :price,
    presence: true,
    numericality: true,
    format: {with: PRICE_REGEXP, message: "は正の数か負の数（小数含む）を入力して下さい。"}
  validates :description,
    allow_nil: true,
    length: {maximum: 80}

end
