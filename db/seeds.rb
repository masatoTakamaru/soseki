require "csv"
require "date"

CSV.foreach("db/seed_student.csv", encoding: 'UTF-8') do |info|
  Student.create!(
    start_date: info[0],
    class_name: info[1],
    family_name: info[2],
    given_name: info[3],
    family_name_kana: info[4],
    given_name_kana: info[5],
    gender: info[6],
    birth_date: info[7],
    school_belong_to: info[8],
    grade: info[9],
    guardian_family_name: info[10],
    guardian_given_name: info[11],
    guardian_family_name_kana: info[12],
    guardian_given_name_kana: info[13],
    phone1: info[14],
    phone1_belong_to: info[15],
    phone2: info[16],
    phone2_belong_to: info[17],
    postal_code: info[18],
    address: info[19],
    email: info[20],
    user_name: info[21],
    password_digest: info[22],
    sibling_group: info[23]
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