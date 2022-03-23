FactoryBot.define do
  factory :student do
     user_id                    {1}
     expire_date                {"2022-04-01"}
     expire_flag                {true}
     start_date                 {"2021-01-01"}
     class_name                 {"中３A"}
     family_name                {"タナカ"}
     given_name                 {"太郎"}
     family_name_kana           {"タナカ"}
     given_name_kana            {"タロウ"}
     gender                     {"男"}
     birth_date                 {"2010-01-01"}
     school_belong_to           {"京都中学校"}
     grade                      {"中学３年"}
     guardian_family_name       {"田中"}
     guardian_given_name        {"次郎"}
     guardian_family_name_kana  {"タナカ"}
     guardian_given_name_kana   {"ジロウ"}
     phone1                     {"092-123-4567"}
     phone1_belong_to           {"自宅"}
     phone2                     {"090-1234-5678"}
     phone2_belong_to           {"母"}
     postal_code                {"1234567"}
     address                    {"京都府京都市"}
     email                      {"sample@gmail.com"}
     user_name                  {"tanakataro"}
     password_digest            {"samplepass"}
     remarks                    {"なし"}
     sibling_group              {"33068A5E-D818-1C3A-B478-D012F931CE71"}
  end
end
