require "date"

class SiblingController < ApplicationController

  include ApplicationHelper
  before_action :authenticate_user!

  @@students_order = {class_name: nil, grade: nil}

  def show
    @student = current_user.students.find_by_hashid(params[:id])
    if params[:class_name]=="asc"
      @@students_order = {class_name: "asc", grade: nil}
    elsif params[:class_name]=="desc"
      @@students_order = {class_name: "desc", grade: nil}
    elsif params[:grade]=="asc"
      @@students_order = {class_name: nil, grade: "asc"}
    elsif params[:grade]=="desc"
      @@students_order = {class_name: nil, grade: "desc"}
    end
    if @@students_order[:class_name] == "asc"
      @students = current_user.students.order(class_name: :asc)
    elsif @@students_order[:class_name] == "desc"
      @students = current_user.students.order(class_name: :desc)
    elsif @@students_order[:grade] == "asc"
      @students = current_user.students.order(grade: :asc)
    elsif @@students_order[:grade] == "desc"
      @students = current_user.students.order(grade: :desc)
    else
      @students = current_user.students
    end
  end

  def update
    sibling = current_user.students.find_by_hashid(params[:sibling_id])
    if sibling.update(sibling_group: params[:sibling_group])
      flash[:notice] = t("notice.update_sibling_group")
    end
    redirect_to sibling_path(params[:id])
  end

  def destroy
    sibling = current_user.students.find_by_hashid(params[:sibling_id])
    if sibling.update(sibling_group: SecureRandom.uuid)
      flash[:notice] = t("notice.destroy_sibling_group")
    end
    redirect_to sibling_path(params[:id])
  end

end
