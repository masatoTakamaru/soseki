require "date"

class StudentController < ApplicationController

  include ApplicationHelper
  before_action :authenticate_user!

  def index
    e = current_user.students.where(expire_flag: false)
    @class_name_order = params[:class_name]
    @grade_order = params[:grade]
    if @class_name_order == "asc"
      @stus = e.order(class_name: :asc)
      @class_name_order = "desc"
    elsif @class_name_order == "desc"
      @stus = e.order(class_name: :desc)
      @class_name_order = "asc"
    elsif @grade_order == "asc"
      @stus = e.order(grade: :asc)
      @grade_order = "desc"
    elsif @grade_order == "desc"
      @stus = e.order(grade: :desc)
      @grade_order = "asc"
    else
      @stus = e
      @class_name_order = "asc"
      @grade_order = "asc"
    end
  end

  def new
    if current_user.students.where(expire_flag: false).count >= @stu_limit
      flash[:notice] = t("notice.student_overlimit")
      redirect_to student_index_path
    end
    @stu = Student.new
  end

  def create
    redirect_to student_index_path if current_user.students.count >= @stu_limit
    @stu = current_user.students.new(student_params)
    @stu[:expire_flag] = false
    @stu[:sibling_group] = SecureRandom.uuid
    if @stu.save
      flash[:notice] = t("notice.new_student_create")
      redirect_to student_index_path
    else
      render action: :new
    end
  end

  def show
    @stu = current_user.students.find_by_hashid(params[:id])
    @sibs = current_user.students.where.not(id: @stu[:id]).where(sibling_group: @stu[:sibling_group])
  end

  def edit
    @stu = current_user.students.find_by_hashid(params[:id])
  end

  def update
    @stu = current_user.students.find_by_hashid(params[:id])
    if @stu.update(student_params)
      flash[:notice] = t("notice.student_update")
      redirect_to student_index_path
    else
      render action: :edit
    end
  end

  def destroy
    @stu = current_user.students.find_by_hashid(params[:id])
    if @stu[:expire_flag]
      @stu.destroy
      flash[:notice] = t("notice.student_destroy")
      redirect_to student_expired_path
    else
      @stu.destroy
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
      @stu = current_user.students.find_by_hashid(params[:id])
      if @stu.update(expire_date: params["student"][:expire_date], expire_flag: true)
        flash[:notice] = t("notice.student_expire")
      else
        flash[:notice] = t("notice.failure")
      end
      redirect_to student_index_path
    end
  end

  def expired
    @stus_count = current_user.students.where(expire_flag: true).count
    @stus = current_user.students.where(expire_flag: true).order(expire_date: :desc).page(params[:page])
  end

  def expire_cancel
    @stu = current_user.students.find_by_hashid(params[:id])
    if @stu.update(expire_date: nil, expire_flag: false)
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
        :email, :remarks, :sibling_group)
    end

end
