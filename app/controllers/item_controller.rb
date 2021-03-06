require "date"

class ItemController < ApplicationController

  include ApplicationHelper
  before_action :authenticate_user!

  def dashboard
    @stus_chart = []
    @total_chart = []
    @book = []
    prds = current_user.items.select(:period).distinct.order(:period).pluck(:period)
    @newest_prd = prds.first
    prds.each do |prd|
      items = current_user.items.where(period: prd)
      qty = items.where(category: 0).pluck(:price).sum
      single = items.where(category: 2).pluck(:price).sum
      admin = items.where(category: 3).pluck(:price).sum
      dtotal = items.where(category: 4).pluck(:price).sum
      total = qty + single + admin - dtotal
      belongs = current_user.students.where("expire_flag = ? and start_date <= ?", false, prd.end_of_month).or(current_user.students.where("expire_flag = ? and start_date <= ? and expire_date >= ?", true, prd.end_of_month, prd)).count
      @stus_chart << [prd.strftime("%y/%m"), belongs]
      @total_chart << [prd.strftime("%y/%m"), total]
      #月ごとの概要を配列として返す
      #period:2022-04-01, text:"2022年4月", belongs:当月の生徒数
      #total:当月請求額, path:生徒別明細ページへのパス
      @book << {
        period: prd,
        text: "#{prd.year} #{t('datetime.prompts.year')} #{prd.month} #{t('datetime.prompts.month')}",
        belongs: belongs,
        total: total,
        path: item_sheet_path(year: prd.year, month: prd.month)
      }
    end
    @book.reverse!

  end

  def before_sheet  #dashboardから帳簿の年月を受け取りindexに渡す
    year = params[:year].to_i
    month = params[:month].to_i
    unless year >= 1980 && year <= 2100 && month >=1 && month <= 12
      flash[:notice] = "正しい年月を入力して下さい。"
      redirect_to dashboard_path and return
    end
    prd = Date.new(year, month, 1)
    if current_user.items.find_by(period: prd).present?
      flash[:notice] = "台帳はすでに存在しています。"
      redirect_to dashboard_path and return
    end
    redirect_to item_sheet_path(year: year, month: month)
  end

  def sheet
    prd = Date.new(params[:year].to_i, params[:month].to_i, 1)
    stus = current_user.students.where("expire_flag = ? and start_date <= ?", false, prd.end_of_month).or(current_user.students.where("expire_flag = ? and start_date <= ? and expire_date >= ?", true, prd.end_of_month, prd))
    @sheet = {
      period: prd,
      period_text: "#{params[:year]} #{t('datetime.prompts.year')} #{params[:month]} #{t('datetime.prompts.month')}",
      belongs: stus.count,
      total: 0,
      item_masters: current_user.item_masters
    }
    @siblings = []
    stus.select(:sibling_group).distinct.pluck(:sibling_group).each do |sibling_group|
      sib = []
      stus.where(sibling_group: sibling_group).each do |stu|
        items = stu.items.where(period: prd)
        if items.find_by(category: 0)
          qty_price = items.find_by(category: 0).price
          qty = items.where(period: prd, category: 1).order(:code)
        else
          qty_price = 0
        end
        single = items.where(period: prd, category: 2).order(:code)
        admin = items.where(period: prd, category: 3).order(:code)
        discount = items.where(period: prd, category: 4).order(:code)
        subtotal = qty_price + single.pluck(:price).sum + admin.pluck(:price).sum
        dtotal = discount.pluck(:price).sum
        total = subtotal - dtotal
        @sheet[:total] += total
        sib << {
          item_present: items.any?,
          student_id: stu.hashid,
          name: "#{stu[:family_name]} #{stu[:given_name]}",
          kana: "#{stu[:family_name_kana]} #{stu[:given_name_kana]}",
          class_name: stu[:class_name],
          grade_name: @grade_name[stu[:grade]],
          total: total
        }
      end
      @siblings << sib
    end

  end

  def sheet_copy
    prds = current_user.items.select(:period).distinct.order(period: :desc).pluck(:period)
    newest_prd = prds.first
    items = current_user.items.where(period: newest_prd)
    flag = true
    items.each do |e|
      item = e.dup
      unless item.update(period: newest_prd.next_month)
        flash[:notice] = "台帳の作成に失敗しました。"
        redirect_to dashboard_path and return
      end
    end
    flash[:notice] = "新規台帳を作成しました。"
    redirect_to dashboard_path
  end

  def bill
    prd = Date.new(params[:year].to_i, params[:month].to_i, 1)
    student = current_user.students.find_by_hashid(params[:student_id])
    items = student.items.where(period: prd)
    item_master = current_user.item_masters
    if items.find_by(category: 0)
      qty_price = items.find_by(category: 0).price
      qty = items.where(category: 1).order(:code)
    else
      qty_price = 0
    end
    single = items.where(category: 2).order(:code)
    admin = items.where(category: 3).order(:code)
    discount = items.where(category: 4).order(:code)
    subtotal = qty_price + single.pluck(:price).sum + admin.pluck(:price).sum
    dtotal = discount.pluck(:price).sum
    total = subtotal - dtotal
    @bill = {
      item_present: items.any?,
      student_id: student.hashid,
      period: prd,
      prd_text: "#{params[:year]} #{t('datetime.prompts.year')} #{params[:month]} #{t('datetime.prompts.month')}",
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
    prd = Date.new(params[:year].to_i, params[:month].to_i, 1)
    qty_items = student.items.where(period: prd, category: 1)
    if qty_items.count == 12
      flash[:notice] = "従量型項目の上限に達しました。これ以上登録できません。"
      redirect_to item_bill_path(params[:student_id], params[:year], params[:month]) and return
    end
    item = student.items.new(
      student_id: student[:id],
      code: item_master[:code],
      period: prd,
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
      qty_items = student.items.where(period: prd, category: 1)
      qty_price = current_user.qty_prices.find_by(grade: student[:grade], qty: qty_items.count)
      qty = student.items.find_by(period: prd, category: 0)
      if qty.present?
        qty.update(price: qty_price[:price])
      else
        qty = student.items.new(
          code: 0,
          period: prd,
          category: 0,
          name: "-",
          price: qty_price[:price],
          description: "-"
        )
        qty.save
      end
    end
    redirect_to item_bill_path(params[:student_id], params[:year], params[:month])
  end

  def destroy_item
    prd = Date.new(params[:year].to_i, params[:month].to_i, 1)
    student = current_user.students.find_by_hashid(params[:student_id])
    item = student.items.find_by(id: params[:id])
    item[:category] == 1 ? qty_flag = true : qty_flag = false
    if item.destroy
      flash[:notice] = "登録項目を削除しました。"
    else
      flash[:notice] = "登録項目の削除に失敗しました。"
    end
    if qty_flag
      qty_items = student.items.where(period: prd, category: 1)
      qty = student.items.find_by(period: prd, category: 0)
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
    prd = Date.new(params[:year].to_i, params[:month].to_i, 1)
    student = current_user.students.find_by_hashid(params[:student_id])
    items = current_user.items.where(student_id: student, period: prd)
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
