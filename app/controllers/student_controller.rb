require "date"

class StudentController < ApplicationController

  before_action :authenticate_user!

  def index
    @students = current_user.students
    #所属クラスのカテゴリ配列の生成
    @classes = @students.order(class_name: :asc).group(:class_name).pluck(:class_name)
    @class_list = []
    @classes.each do |c|
      @class_list.push([c,c])
    end
    if params[:class_name]
      if params[:class_name].present?
        @class_name = params[:class_name]
        @students = @students.where(class_name: @class_name)
      else
        @students = @students.order(created_at: :desc)
      end
    #学年の抽出
    elsif params[:grade]
      if params[:grade].present?
        @grade = params[:grade]
        @students = @students.where(grade: @grade)
      else
        @students = @students.order(created_at: :desc)
      end
    else
      @students = @students.all.order(created_at: :desc)
    end
  end

  def new
    @student = Student.new
  end

  def create
    @student = current_user.students.new(student_params)
    if @student.save
      flash[:notice] = t("notice.new_student_created")
      redirect_to student_index_path
    else
      render new_student_path
    end
  end

  def show
    @student = current_user.students.find(params[:id])
    @student_full_name = @student[:family_name] + " " + @student[:given_name]
    if @student[:sibling_group].present?
      @siblings = current_user.students.where(sibling_group: @student[:sibling_group])
    end
  end

  def edit
    @student = Student.find_by(student_id: params[:id])
  end

  def update
    @student = Student.find_by(student_id: params[:id])
    #paramsのデータを一つずつ取り出し@studentを更新
    params[:student].each do |key, value|
      if key == "password"
        #passwordだけ別処理
        @student.password = params[:student][:password]
      else
        @student[key] = params[:student][key]
      end
    end
    @student[:company_id] = current_user.company_id
    
    if @student.save
      flash[:notice] = "生徒情報が更新されました。"
      redirect_to student_index_path
    else
      render "edit"
    end
  end

  def destroy
    @student = Student.find_by(student_id: params[:id])
    @student.destroy
    flash[:notice] = "生徒が削除されました。"
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
