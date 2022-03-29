class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :students, dependent: :destroy
  has_many :item_masters, dependent: :destroy
  has_many :items, through: :students

  
  validates :username,
    presence: true,
    length: {maximum: 20}
  
end
