require "csv"
require "date"


CSV.foreach("db/seed_student.csv", encoding: 'UTF-8') do |line|
  Student.create!(
    user_id: line[0],
    start_date: line[1],
    class_name: line[2],
    family_name: line[3],
    given_name: line[4],
    family_name_kana: line[5],
    given_name_kana: line[6],
    gender: line[7],
    birth_date: line[8],
    school_belong_to: line[9],
    grade: line[10],
    guardian_family_name: line[11],
    guardian_given_name: line[12],
    guardian_family_name_kana: line[13],
    guardian_given_name_kana: line[14],
    phone1: line[15],
    phone1_belong_to: line[16],
    phone2: line[17],
    phone2_belong_to: line[18],
    postal_code: line[19],
    address: line[20],
    email: line[21],
    user_name: line[22],
    password_digest: line[23],
    sibling_group: line[24]
    )
end

=begin
CSV.foreach("db/seed-ken-all.csv", encoding: 'UTF-8') do |line|
  Postal.create(
    postal_code: line[0],
    prefecture: line[1],
    city: line[2],
    town: line[3],
    )
end
=end