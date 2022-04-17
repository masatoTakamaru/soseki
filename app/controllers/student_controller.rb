require "date"

class StudentController < ApplicationController

  include ApplicationHelper
  before_action :authenticate_user!

  def index
    @students = student_sort(current_user.students.where(expire_flag: false))
  end

  def new
    if current_user.students.where(expire_flag: false).count >= @student_limit
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
    @siblings = current_user.students.where.not(id: @student[:id]).where(sibling_group: @student[:sibling_group])
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
    if @student[:expire_flag]
      @student.destroy
      flash[:notice] = t("notice.student_destroy")
      redirect_to student_expired_path
    else
      @student.destroy
      flash[:notice] = t("notice.student_destroy")
      redirect_to student_index_path
    end
  end

  #卒・退会処理
  def expire
    if current_user.students.where(expire_flag: true).count >= @expire_student_limit
      flash[:notice] = t("notice.expire_student_overlimit")
      redirect_to student_path(params[:id])
    else
      @student = current_user.students.find_by_hashid(params[:id])
      if @student.update(expire_date: params["student"][:expire_date], expire_flag: true)
        flash[:notice] = t("notice.student_expire")
      else
        flash[:notice] = t("notice.failure")
      end
      redirect_to student_index_path
    end
  end

  def expired
    @students_count = current_user.students.where(expire_flag: true).count
    @students = current_user.students.where(expire_flag: true).order(expire_date: :desc).page(params[:page])
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
