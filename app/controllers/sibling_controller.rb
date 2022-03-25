require "date"

class SiblingController < ApplicationController

before_action :authenticate_user!

#兄弟・姉妹の設定
def show
  #所属クラスのカテゴリ配列の生成
  @students = Student.where(company_id: current_user[:company_id])
  @student = @students.find_by(student_id: params[:id])
  @categories = @students.order(class_name: :asc).group(:class_name).pluck(:class_name)
  @category_index = []
  @categories.each do |c|
    @category_index.push([c,c])
  end
  #所属クラスの抽出
  if params[:class_name]
    if params[:class_name].present?
      @class_name = params[:class_name]
      @students = @students.where(class_name: @class_name)
    else
      @students = @students.all.order(created_at: :desc)
    end
  #学年の抽出
  elsif params[:grade]
    if params[:grade].present?
      @grade = params[:grade]
      @students = @students.where(grade: @grade)
    else
      @students = @students.all.order(created_at: :desc)
    end
  else
    @students = @students.all.order(created_at: :desc)
  end
end

#兄弟姉妹の更新
def update
  @student = Student.find_by(student_id: params[:sibling_id])
  @student.sibling_group = params[:sibling_group]
  if @student.save
    flash[:notice] = "兄弟・姉妹を設定しました。"
  end
  redirect_to sibling_path(params[:student_id])
end

#兄弟姉妹設定の消去
def destroy
  @sibling = Student.find_by(student_id: params[:sibling_id])
  @sibling[:sibling_group] = SecureRandom.uuid
  if @sibling.save
    flash[:notice] = "設定を解除しました。"
  end
  redirect_to sibling_path(params[:student_id])
end


end
