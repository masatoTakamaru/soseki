require "date"

class StudentController < ApplicationController

  include ApplicationHelper
  before_action :authenticate_user!

  def index
    if params[:class_name]=="asc"
      @students = current_user.students.order(class_name: :asc)
    elsif params[:class_name]=="desc"
      @students = current_user.students.order(class_name: :desc)
    elsif params[:grade]=="asc"
      @students = current_user.students.order(grade: :asc)
    elsif params[:grade]=="desc"
      @students = current_user.students.order(grade: :desc)
    else
      @students = current_user.students
    end
  end

  def new
    if current_user.students.count >= 30
      flash[:notice] = t("notice.over_limit")
      redirect_to student_index_path
    end
    @student = Student.new
  end

  def create
    if current_user.students.count >= 30
      flash[:notice] = t("notice.over_limit")
      redirect_to student_index_path
    end
    @student = current_user.students.new(student_params)
    if @student.save
      flash[:notice] = t("notice.new_student_created")
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
      flash[:notice] = t("notice.student_updated")
      redirect_to student_index_path
    else
      render edit_student_path
    end
  end

  def destroy
    @student = current_user.students.find(params[:id])
    @student.destroy
    flash[:notice] = t("notice.student_destroy")
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
