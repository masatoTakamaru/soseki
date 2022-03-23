require "csv"
require "date"

CSV.foreach("db/seed_student.csv", encoding: 'UTF-8') do |info|
  Student.create!(
    user_id: info[0],
    start_date: info[1],
    class_name: info[2],
    family_name: info[3],
    given_name: info[4],
    family_name_kana: info[5],
    given_name_kana: info[6],
    gender: info[7],
    birth_date: info[8],
    school_belong_to: info[9],
    grade: info[10],
    guardian_family_name: info[11],
    guardian_given_name: info[12],
    guardian_family_name_kana: info[13],
    guardian_given_name_kana: info[14],
    phone1: info[15],
    phone1_belong_to: info[16],
    phone2: info[17],
    phone2_belong_to: info[18],
    postal_code: info[19],
    address: info[20],
    email: info[21],
    user_name: info[22],
    password_digest: info[23],
    sibling_group: info[24]
    )
end

=begin
CSV.foreach("db/seed-ken-all.csv", encoding: 'UTF-8') do |info|
  Postal.create(
    postal_code: info[0],
    prefecture: info[1],
    city: info[2],
    town: info[3],
    )
end
=end