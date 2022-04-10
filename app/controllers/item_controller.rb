require "date"

class ItemController < ApplicationController

  include ApplicationHelper
  before_action :authenticate_user!

  def dashboard
    @students = current_user.students
    @item_masters = current_user.item_masters
    periods = current_user.items.select(:period).distinct.pluck(:period)
    @sheets = []
    periods.each do |period|
      #月ごとの概要を配列として返す
      #period: 2022-04-01
      #text: "2022年4月"
      #belongs: 当月の生徒数
      #total: 当月請求額
      #path: 生徒別明細ページへのパス
      @sheets << {
        period: period,
        text: "#{period.year} #{t('datetime.prompts.year')} #{period.month} #{t('datetime.prompts.month')}",
        belongs: current_user.items.where(period: period).select(:student_id).distinct.pluck(:student_id).count,
        total: current_user.items.where(period: period).pluck(:price).sum,
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
    redirect_to item_index_path(year: year, month: month)
  end

  def sheet
    student_sort
    @period = Date.new(params[:year].to_i, params[:month].to_i, 1)
  end

  def new
    @student = current_user.students.find_by_hashid(params[:student_id])
    @item_masters = current_user.item_masters
    period = Date.new(params[:year].to_i, params[:month].to_i, 1)
    @items = @student.items.where(student_id: @student[:id], period: period).order(code: :asc)
    @total_price = @items.all.sum(:price)
    #コードによる講座検索
    if params[:code].present?
      if @item_masters.find_by(code: params[:code])
        @new_item = @item_masters.find_by(code: params[:code])
        flash[:notice] = nil
      else
        @new_item = nil
        flash[:notice] = "講座が見つかりません。"
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
      flash[:notice] = "講座を追加しました。"
    else
      flash[:notice] = "講座の追加に失敗しました。"
    end
    redirect_to new_item_url(params[:student_id], params[:year], params[:month])
  end

  def destroy
    item = current_user.items.find_by(id: params[:id])
    if item.destroy
      flash[:notice] = "登録講座を削除しました。"
    else
      flash[:notice] = "登録講座の削除に失敗しました。"
    end
    redirect_to new_item_url(params[:student_id], params[:year], params[:month])
  end

end
