require "date"

class ItemController < ApplicationController

  include ApplicationHelper
  before_action :authenticate_user!

  def dashboard
    @book = []
    periods = current_user.items.select(:period).distinct.order(period: :desc).pluck(:period)
    periods.each do |period|
      items = current_user.items.where(period: period)
      qty = items.where(category: 0).pluck(:price).sum
      single = items.where(category: 2).pluck(:price).sum
      admin = items.where(category: 3).pluck(:price).sum
      dtotal = items.where(category: 4).pluck(:price).sum
      total = qty + single + admin - dtotal
      #月ごとの概要を配列として返す
      #period:2022-04-01, text:"2022年4月", belongs:当月の生徒数
      #total:当月請求額, path:生徒別明細ページへのパス
      @book << {
        period: period,
        text: "#{period.year} #{t('datetime.prompts.year')} #{period.month} #{t('datetime.prompts.month')}",
        belongs: current_user.items.where(period: period).select(:student_id).distinct.pluck(:student_id).count,
        total: total,
        path: item_sheet_path(year: period.year, month: period.month)
      }
    end

  end

  def before_sheet  #dashboardから帳簿の年月を受け取りindexに渡す
    year = params[:year].to_i
    month = params[:month].to_i
    unless year >= 1980 && year <= 2100 && month >=1 && month <= 12
      flash[:notice] = "正しい年月を入力して下さい。"
      redirect_to dashboard_path and return
    end
    period = Date.new(year, month, 1)
    if current_user.items.find_by(period: period).present?
      flash[:notice] = "台帳はすでに存在しています。"
      redirect_to dashboard_path and return
    end
    redirect_to item_sheet_path(year: year, month: month)
  end

  def sheet
    period = Date.new(params[:year].to_i, params[:month].to_i, 1)
    students = current_user.students.where(expire_flag: false)
    @sheet = {
      period: period,
      period_text: "#{params[:year]} #{t('datetime.prompts.year')} #{params[:month]} #{t('datetime.prompts.month')}",
      belongs: students.count,
      total: 0,
      item_masters: current_user.item_masters
    }
    @siblings = []
    students.select(:sibling_group).distinct.pluck(:sibling_group).each do |sibling_group|
      sibling = []
      students.where(sibling_group: sibling_group).each do |student|
        items = student.items.where(period: period)
        if items.find_by(category: 0)
          qty_price = items.find_by(category: 0).price
          qty = items.where(period: period, category: 1).order(code: :asc)
        else
          qty_price = 0
        end
        single = items.where(period: period, category: 2).order(code: :asc)
        admin = items.where(period: period, category: 3).order(code: :asc)
        discount = items.where(period: period, category: 4).order(code: :asc)
        subtotal = qty_price + single.pluck(:price).sum + admin.pluck(:price).sum
        dtotal = discount.pluck(:price).sum
        total = subtotal - dtotal
        @sheet[:total] += total
        sibling << {
          item_present: student.items.present?,
          student_id: student.hashid,
          name: "#{student[:family_name]} #{student[:given_name]}",
          kana: "#{student[:family_name_kana]} #{student[:given_name_kana]}",
          class_name: student[:class_name],
          grade_name: @grade_name[student[:grade]],
          total: total
        }
      end
      @siblings << sibling
    end

  end

  def bill
    period = Date.new(params[:year].to_i, params[:month].to_i, 1)
    student = current_user.students.find_by_hashid(params[:student_id])
    items = student.items.where(period: period)
    item_master = current_user.item_masters
    if items.find_by(category: 0)
      qty_price = items.find_by(category: 0).price
      qty = items.where(category: 1).order(code: :asc)
    else
      qty_price = 0
    end
    single = items.where(category: 2).order(code: :asc)
    admin = items.where(category: 3).order(code: :asc)
    discount = items.where(category: 4).order(code: :asc)
    subtotal = qty_price + single.pluck(:price).sum + admin.pluck(:price).sum
    dtotal = discount.pluck(:price).sum
    total = subtotal - dtotal
    @bill = {
      item_present: items.present?,
      student_id: student.hashid,
      period: period,
      period_text: "#{params[:year]} #{t('datetime.prompts.year')} #{params[:month]} #{t('datetime.prompts.month')}",
      name: "#{student[:family_name]} #{student[:given_name]}",
      kana: "#{student[:family_name_kana]} #{student[:given_name_kana]}",
      class_name: student[:class_name],
      grade_name: @grade_name[student[:grade]],
      qty: qty,
      single: single,
      admin: admin,
      discount: discount,
      qty_price: qty_price,
      subtotal: subtotal,
      dtotal: dtotal,
      total: total
    }
    #コードによる講座検索
    if params[:code].present?
      if item_master.find_by(code: params[:code])
        @new_item = item_master.find_by(code: params[:code])
        flash[:notice] = nil
      else
        @new_item = nil
        flash[:notice] = "項目が見つかりません。"
      end
    else
      @new_item = nil
    end
  end

  def create
    item_master = current_user.item_masters.find_by(code: params[:code])
    student = current_user.students.find_by_hashid(params[:student_id])
    period = Date.new(params[:year].to_i, params[:month].to_i, 1)
    qty_items = student.items.where(period: period, category: 1)
    if qty_items.count == 12
      flash[:notice] = "従量型項目の上限に達しました。これ以上登録できません。"
      redirect_to item_bill_path(params[:student_id], params[:year], params[:month]) and return
    end
    item = student.items.new(
      student_id: student[:id],
      code: item_master[:code],
      period: period,
      category: item_master[:category],
      name: item_master[:name],
      price: item_master[:price],
      description: item_master[:description]
    )
    if item.save
      flash[:notice] = "項目を追加しました。"
    else
      flash[:notice] = "項目の追加に失敗しました。"
    end
    if item[:category] == 1
      qty_items = student.items.where(period: period, category: 1)
      qty_price = current_user.qty_prices.find_by(grade: student[:grade], qty: qty_items.count)
      qty = student.items.find_by(period: period, category: 0)
      if qty.present?
        qty.update(price: qty_price[:price])
      else
        qty = student.items.new(
          code: 0,
          period: period,
          category: 0,
          name: "[qty]",
          price: qty_price[:price],
          description: "[qty]"
        )
        qty.save
      end
    end
    redirect_to item_bill_path(params[:student_id], params[:year], params[:month])
  end

  def destroy_item
    period = Date.new(params[:year].to_i, params[:month].to_i, 1)
    student = current_user.students.find_by_hashid(params[:student_id])
    item = student.items.find_by(id: params[:id])
    item[:category] == 1 ? qty_flag = true : qty_flag = false
    if item.destroy
      flash[:notice] = "登録項目を削除しました。"
    else
      flash[:notice] = "登録項目の削除に失敗しました。"
    end
    if qty_flag
      qty_items = student.items.where(period: period, category: 1)
      qty = student.items.find_by(period: period, category: 0)
      if qty_items.count == 0
        qty.destroy
      else
        qty_price = current_user.qty_prices.find_by(grade: student[:grade], qty: qty_items.count)
        qty.update(price: qty_price[:price])
      end
    end
    redirect_to item_bill_url(params[:student_id], params[:year], params[:month])
  end

  def destroy_bill
    period = Date.new(params[:year].to_i, params[:month].to_i, 1)
    student = current_user.students.find_by_hashid(params[:student_id])
    items = current_user.items.where(student_id: student, period: period)
    if items.destroy_all
      flash[:notice] = "登録項目を削除しました。"
    else
      flash[:notice] = "登録項目の削除に失敗しました。"
    end
    redirect_to item_sheet_url(params[:year], params[:month])
  end

  private

  def item_params
    params.permit(:year, :month, :id, :student_id, :code)
  end


end
