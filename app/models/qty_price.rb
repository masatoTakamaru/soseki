class QtyPrice < ApplicationRecord

  belongs_to :user

  PRICE_REGEXP = /\A[0-9]+\.?[0-9]*\z/
  validates :price,
  presence: true,
  format: {with: PRICE_REGEXP, message: "に誤りがあります。"}

end
