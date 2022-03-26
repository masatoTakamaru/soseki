class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?

  def initialize

    super

    #学年の定義
    @grades = [
      "未就学", "年少", "年中", "年長",
      "小学１年", "小学２年", "小学３年",
      "小学４年", "小学５年", "小学６年",
      "中学１年", "中学２年", "中学３年",
      "高校１年", "高校２年", "高校３年",
      "既卒"
    ]

  end

  def student_extraction  #所属クラス・学年による生徒の抽出
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

  protected

  def configure_permitted_parameters
    # deviseのstrongparameter
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

end
