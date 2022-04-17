require "date"

class ItemController < ApplicationController

  include ApplicationHelper
  before_action :authenticate_user!

  def dashboard
    periods = current_user.items.select(:period).distinct.order(period: :desc).pluck(:period)
    @book = []
    periods.each do |period|
      subtotal = current_user.items.where.not(category: 3).where(period: period).pluck(:price).sum
      discount = current_user.items.where(category: 3).where(period: period).pluck(:price).sum
      total = subtotal - discount
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
    qty_prices = QtyPrice.all.order(qty: :asc).pluck(:price)
    qty_prices.unshift(0)
    students = student_sort(current_user.students.where(expire_flag: false))
    @sheet = {
      period: period,
      period_text: "#{params[:year]} #{t('datetime.prompts.year')} #{params[:month]} #{t('datetime.prompts.month')}",
      belongs: students.count,
      total: 0,
      students: [],
      item_masters: current_user.item_masters,
    }
    students.each do |student|
      current_user.items.where(student_id: student[:id], period: period).present? ? items_present = true : items_present = false
      qty_items = current_user.items.where(category: 1).where(student_id: student[:id], period: period)
      qty_total = qty_prices[qty_items.count]
      subtotal = current_user.items.where(category: 0).where(student_id: student[:id], period: period).pluck(:price).sum + qty_total + current_user.items.where(category: 2).where(student_id: student[:id], period: period).pluck(:price).sum
      discount = current_user.items.where(category: 3).where(student_id: student[:id], period: period).pluck(:price).sum
      total = subtotal - discount
      @sheet[:total] += total
      @sheet[:students] << {
        items_present: items_present,
        student_id: student.hashid,
        name: "#{student[:family_name]} #{student[:given_name]}",
        kana: "#{student[:family_name_kana]} #{student[:given_name_kana]}",
        class_name: student[:class_name],
        grade_name: @grade_name[student[:grade]],
        total: total.to_s(:delimited)
      }
    end
  end

  def bill
    @period = Date.new(params[:year].to_i, params[:month].to_i, 1)
    @student = current_user.students.find_by_hashid(params[:student_id])
    @item_master = current_user.item_masters
    @single_items = @student.items.where(period: @period, category: 0).order(code: :asc)
    @qty_items = @student.items.where(period: @period, category: 1).order(code: :asc)
    @admin_items = @student.items.where(period: @period, category: 2).order(code: :asc)
    @discounts = @student.items.where(period: @period, category: 3).order(code: :asc)
    qty_prices = QtyPrice.all.order(qty: :asc).pluck(:price)
    qty_prices.unshift(0)
    @bill = {
      student_id: @student.hashid,
      period: @period,
      period_text: "#{params[:year]} #{t('datetime.prompts.year')} #{params[:month]} #{t('datetime.prompts.month')}",
      name: "#{@student[:family_name]} #{@student[:given_name]}",
      kana: "#{@student[:family_name_kana]} #{@student[:given_name_kana]}",
      class_name: @student[:class_name],
      grade_name: @grade_name[@student[:grade]],
      qty_total: qty_prices[@qty_items.count].to_f.to_s(:delimited),
      subtotal: (@single_items.pluck(:price).sum + qty_prices[@qty_items.count].to_f + @admin_items.pluck(:price).sum).to_s(:delimited),
      discount: @discounts.pluck(:price).sum.to_s(:delimited),
      total: (@single_items.pluck(:price).sum + qty_prices[@qty_items.count].to_f + @admin_items.pluck(:price).sum - @discounts.pluck(:price).sum).to_s(:delimited)
    }
    #コードによる講座検索
    if params[:code].present?
      if @item_master.find_by(code: params[:code])
        @new_item = @item_master.find_by(code: params[:code])
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
    date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    item = student.items.new(
      student_id: student[:id],
      code: item_master[:code],
      period: date,
      class_name: student[:class_name],
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
    redirect_to item_bill_path(params[:student_id], params[:year], params[:month])
  end

  def destroy_item
    item = current_user.items.find_by(id: params[:id])
    if item.destroy
      flash[:notice] = "登録項目を削除しました。"
    else
      flash[:notice] = "登録項目の削除に失敗しました。"
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
