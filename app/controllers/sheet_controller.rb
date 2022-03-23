require "date"

class SheetController < ApplicationController

  before_action :authenticate_user!

  def index
    @students = Student.where(company_id: current_user[:company_id])
    @ledgers = Ledger.where(company_id: current_user[:company_id])
    @ledger_dates = @ledgers.order(ledger_date: :desc).group(:ledger_date).pluck(:ledger_date)
  end

  def create
    if params[:year].to_i.between?(2000,3000) && params[:month].to_i.between?(1,12)
      @ledger_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
      @students = Student.where(company_id: current_user[:company_id])
      save_flag = true
      @students.each do |student|
        @ledger = Ledger.new
        @ledger[:ledger_date] = @ledger_date
        @ledger[:student_id] = student[:student_id]
        @ledger[:company_id] = current_user[:company_id]
        unless @ledger.save!
          save_flag == false
        end
      end
      save_flag == true ? flash[:notice] = "台帳が作成されました。" : flash[:notice] = "台帳の作成に失敗しました。"
      redirect_to dashboard_path
    else
      flash[:notice] = "正しい年月を入力して下さい"
      redirect_to dashboard_path
    end
  end

end
