require "date"

class StudentController < ApplicationController

  include ApplicationHelper
  before_action :authenticate_user!

  def index
    @students = current_user.students.where(expire_flag: false)
    if params[:class_name]=="asc"
      @students = @students.order(class_name: :asc)
    elsif params[:class_name]=="desc"
      @students = @students.order(class_name: :desc)
    elsif params[:grade]=="asc"
      @students = @students.order(grade: :asc)
    elsif params[:grade]=="desc"
      @students = @students.order(grade: :desc)
    end
  end

  def new
    if current_user.students.count >= @student_limit
      flash[:notice] = t("notice.student_overlimit")
      redirect_to student_index_path
    end
    @student = Student.new
  end

  def create
    redirect_to student_index_path if current_user.students.count >= @student_limit
    @student = current_user.students.new(student_params)
    @student[:expire_flag] = false
    @student[:sibling_group] = SecureRandom.uuid
    if @student.save
      flash[:notice] = t("notice.new_student_create")
      redirect_to student_index_path
    else
      render new_student_path
    end
  end

  def show
    @student = current_user.students.find_by_hashid(params[:id])
    @student_full_name = @student[:family_name] + " " + @student[:given_name]
    @siblings = current_user.students.where(sibling_group: @student[:sibling_group])
  end

  def edit
    @student = current_user.students.find_by_hashid(params[:id])
  end

  def update
    @student = current_user.students.find_by_hashid(params[:id])
    if @student.update(student_params)
      flash[:notice] = t("notice.student_update")
      redirect_to student_index_path
    else
      render action: :edit
    end
  end

  def destroy
    @student = current_user.students.find_by_hashid(params[:id])
    @student.destroy
    flash[:notice] = t("notice.student_destroy")
    redirect_to student_index_path
  end

  #卒・退会処理
  def expire
    @student = current_user.students.find_by_hashid(params[:id])
    if @student.update(expire_date: params["student"][:expire_date], expire_flag: true)
      flash[:notice] = t("notice.student_expire")
    else
      flash[:notice] = t("notice.failure")
    end
    redirect_to student_index_path
  end

  def expired
    @students = current_user.students.where(expire_flag: true).order(expire_date: :desc)
  end

  def expire_cancel
    @student = current_user.students.find_by_hashid(params[:id])
    if @student.update(expire_date: nil, expire_flag: false)
      flash[:notice] = t("notice.student_expire_cancel")
    else
      flash[:notice] = t("notice.failure")
    end
    redirect_to student_index_path
  end

  #前月の名簿の引き継ぎ
  def copy_prev_month
    @students = Student.where(fiscal_date: params[:fiscal_date])
    @students.destroy_all
    fiscal_prev = Date.parse(params[:fiscal_date]).prev_month
    @students = Student.where(fiscal_date: fiscal_prev)
    save_flag = true
    @students.each do |student|
      student_next = student.dup
      student_next[:fiscal_date] = params[:fiscal_date]
      unless student_next.save
        save_flag = false
      end
    end
    if save_flag
      flash[:notice] = "名簿が転記されました。"
    else
      flash[:notice] = "名簿の転記が失敗しました。"
    end
    redirect_to student_index_path
  end

  #進級処理の確認画面
  def advance_grade_confirm
  end

  #進級処理の実行
  def advance_grade_run
  end

  private

    def student_params
      params.require(:student).permit(
        :user_id, :expire_date, :expire_flag, :start_date, :class_name,
        :family_name, :given_name, :family_name_kana, :given_name_kana,
        :gender, :birth_date, :school_belong_to, :grade,
        :guardian_family_name, :guardian_given_name,
        :guardian_family_name_kana, :guardian_given_name_kana,
        :phone1, :phone1_belong_to, :phone2, :phone2_belong_to,
        :postal_code, :address, :email, :user_name, :password,
        :remarks, :sibling_group)
    end

end
