class HomeController < ApplicationController

  require "csv"
  require "date"

  include ApplicationHelper
  before_action :authenticate_user!,
    except: [:index, :help, :privacy_policy, :contact]

  def index
  end

  def students_csv_download
    str = "activerecord.attributes.student"
    csv_data = CSV.generate("\uFEFF") do |csv|
      csv << [
        t("#{str}.start_date"),
        t("#{str}.class_name"),
        t("#{str}.family_name"),
        t("#{str}.given_name"),
        t("#{str}.family_name_kana"),
        t("#{str}.given_name_kana"),
        t("#{str}.gender"),
        t("#{str}.birth_date"),
        t("#{str}.school_belong_to"),
        t("#{str}.guardian_family_name"),
        t("#{str}.guardian_given_name"),
        t("#{str}.guardian_family_name_kana"),
        t("#{str}.guardian_given_name_kana"),
        t("#{str}.phone1"),
        t("#{str}.phone1_belong_to"),
        t("#{str}.phone2"),
        t("#{str}.phone2_belong_to"),
        t("#{str}.email"),
        t("#{str}.remarks")
      ]
      stus = current_user.students.where(expire_flag: false)
      stus.each do |stu|
        csv << [
          stu[:start_date],
          stu[:class_name],
          stu[:family_name],
          stu[:given_name],
          stu[:family_name_kana],
          stu[:given_name_kana],
          stu[:gender],
          stu[:birth_date],
          stu[:school_belong_to],
          stu[:guardian_family_name],
          stu[:guardian_given_name],
          stu[:guardian_family_name_kana],
          stu[:guardian_given_name_kana],
          stu[:phone1],
          stu[:phone1_belong_to],
          stu[:phone2],
          stu[:phone2_belong_to],
          stu[:email],
          stu[:remarks]
        ]
      end
    end
    send_data csv_data, filename: "生徒#{DateTime.current.to_s(:db)}.csv"
  end

  def expired_csv_download
    str = "activerecord.attributes.student"
    csv_data = CSV.generate("\uFEFF") do |csv|
      csv << [
        t("#{str}.start_date"),
        t("#{str}.class_name"),
        t("#{str}.family_name"),
        t("#{str}.given_name"),
        t("#{str}.family_name_kana"),
        t("#{str}.given_name_kana"),
        t("#{str}.gender"),
        t("#{str}.grade"),
        t("#{str}.birth_date"),
        t("#{str}.school_belong_to"),
        t("#{str}.guardian_family_name"),
        t("#{str}.guardian_given_name"),
        t("#{str}.guardian_family_name_kana"),
        t("#{str}.guardian_given_name_kana"),
        t("#{str}.phone1"),
        t("#{str}.phone1_belong_to"),
        t("#{str}.phone2"),
        t("#{str}.phone2_belong_to"),
        t("#{str}.email"),
        t("#{str}.remarks")
      ]
      stus = current_user.students.where(expire_flag: true)
      stus.each do |stu|
        csv << [
          stu[:start_date],
          stu[:class_name],
          stu[:family_name],
          stu[:given_name],
          stu[:family_name_kana],
          stu[:given_name_kana],
          stu[:gender],
          stu[:grade],
          stu[:birth_date],
          stu[:school_belong_to],
          stu[:guardian_family_name],
          stu[:guardian_given_name],
          stu[:guardian_family_name_kana],
          stu[:guardian_given_name_kana],
          stu[:phone1],
          stu[:phone1_belong_to],
          stu[:phone2],
          stu[:phone2_belong_to],
          stu[:email],
          stu[:remarks]
        ]
      end
    end
    send_data csv_data, filename: "卒・退会者#{DateTime.current.to_s(:db)}.csv"
  end

  def item_master_csv_download
    str = "activerecord.attributes.item_master"
    csv_data = CSV.generate("\uFEFF") do |csv|
      csv << [
        t("#{str}.code"),
        t("#{str}.name"),
        t("#{str}.description"),
        t("#{str}.category"),
        t("#{str}.price")
      ]
      item_masters = current_user.item_masters.order(code: :asc)
      item_masters.each do |item_master|
        item_master[:category] == 1 ? price = "-" : price = item_master[:price]
        csv << [
          item_master[:code],
          item_master[:name],
          item_master[:description],
          @item_cats[item_master[:category]],
          price
        ]
      end
    end
    send_data csv_data, filename: "講座と費用#{DateTime.current.to_s(:db)}.csv"
  end

  def item_csv_download
    str = "activerecord.attributes"
    csv_data = CSV.generate("\uFEFF") do |csv|
      csv << [
        t("datetime.prompts.year"),
        t("datetime.prompts.month"),
        t("#{str}.student.class_name"),
        t("#{str}.student.family_name"),
        t("#{str}.student.given_name"),
        t("#{str}.student.family_name_kana"),
        t("#{str}.student.given_name_kana"),
        t("#{str}.student.grade"),
        t("#{str}.item_master.code"),
        t("#{str}.item_master.name"),
        t("#{str}.item_master.description"),
        t("#{str}.item_master.category"),
        t("#{str}.item_master.price")
      ]
      items = current_user.items.order(:period).order(:student_id).order(:code)
      items.each do |item|
        stu = current_user.students.find_by(id: item[:student_id])
        if item[:category] == 0
          code = "-"
          cat = "従量小計"
        else
          code = item[:code]
          cat = @item_cats[item[:category]]
        end
        item[:category] == 1 ? price = "-" : price = item[:price]
        csv << [
          item[:period].year,
          item[:period].month,
          stu[:class_name],
          stu[:family_name],
          stu[:given_name],
          stu[:family_name_kana],
          stu[:given_name_kana],
          @grade_name[stu[:grade]],
          code,
          item[:name],
          item[:description],
          cat,
          price
        ]
      end
    end
    send_data csv_data, filename: "月謝#{DateTime.current.to_s(:db)}.csv"
  end

end
