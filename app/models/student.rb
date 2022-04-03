class Student < ApplicationRecord
  include Hashid::Rails

  belongs_to :user
  has_many :items, dependent: :destroy
  
  has_secure_password validations: false

  HUMAN_NAME_REGEXP = /\A[\p{han}\p{hiragana}\p{katakana}\u{30fc}A-Za-z]+\z/
  KATAKANA_REGEXP = /\A[ァ-ヶー－]+\z/
  PHONE_NUMBER_REGEXP = /\A\d{2,5}-\d{2,5}-\d{2,5}\z/
  POSTAL_CODE_REGEXP = /\A\d{7}\z/
  EMAIL_REGEXP = /\A\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*\z/
  USER_NAME_REGEXP = /\A[ -~]+\z/
  PASSWORD_REGEXP = /\A[ -~]+\z/

  validates :start_date,
    presence: {message: "に誤りがあります。正しい日付を入力して下さい。"}
  validates :expire_date,
    allow_nil: true,
    presence: {message: "に誤りがあります。正しい日付を入力して下さい。"}
  validates :class_name,
    presence: true,
    length: {maximum: 10}
  validates :family_name, :given_name,
    presence: true,
    length: {maximum: 20},
    format: {with: HUMAN_NAME_REGEXP, message: "は漢字、ひらがな、カタカナ、アルファベットのいずれかを入力して下さい。"}
  validates :family_name_kana, :given_name_kana,
    presence: true,
    length: {maximum: 20},
    format: {with: KATAKANA_REGEXP, message: "は全角カタカナで入力して下さい。"}
  validates :gender, presence: true
  validates :school_belong_to,
    length: {maximum: 40}
  validates :grade,
    allow_nil: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 16}
  validates :guardian_family_name, :guardian_given_name,
    allow_blank: true,
    length: {maximum: 20},
    format: {with: HUMAN_NAME_REGEXP, message: "は漢字、ひらがな、カタカナ、アルファベットのいずれかを入力して下さい。"}
  validates :guardian_family_name_kana, :guardian_given_name_kana,
    allow_blank: true,
    length: {maximum: 20},
    format: {with: KATAKANA_REGEXP, message: "は全角入力して下さい。"}
  validates :phone1,
    presence: true,
    format: {with: PHONE_NUMBER_REGEXP, message: "に誤りがあります。"}
  validates :phone1_belong_to,
    allow_nil: true,
    length: {maximum: 10}
  validates :phone2,
    format: {with: PHONE_NUMBER_REGEXP, message: "に誤りがあります。",
              allow_blank: true}
  validates :phone2_belong_to,
    allow_blank: true,
    length: {maximum: 10}
  validates :postal_code,
    presence: true,
    format: {with: POSTAL_CODE_REGEXP, message: "に誤りがあります。"}
  validates :address,
    presence: true,
    length: {maximum: 40}
  validates :email,
    length: {maximum: 72},
    format: {with: EMAIL_REGEXP, message: "に誤りがあります。",
              allow_blank: true}
  validates :user_name,
    length: {maximum: 20},
    format: {with: USER_NAME_REGEXP, message: "は半角文字で入力して下さい。",
            allow_blank: true}
  validates :password,
    length: {maximum: 40},
    format: {with: PASSWORD_REGEXP, message: "は半角文字で入力して下さい。",
            allow_blank: true}    
  validates :remarks, length: {maximum: 240}

end
