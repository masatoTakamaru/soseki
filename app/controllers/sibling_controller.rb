require "date"

class SiblingController < ApplicationController

  include ApplicationHelper
  before_action :authenticate_user!


  def show
    @student = current_user.students.find_by_hashid(params[:id])
    @students = current_user.students.where(expire_flag: false)
    if params[:class_name] == "asc"
      @students = @students.order(class_name: :asc)
    elsif params[:class_name] == "desc"
      @students = @students.order(class_name: :desc)
    elsif params[:grade] == "asc"
      @students = @students.order(grade: :asc)
    elsif params[:grade] == "desc"
      @students = @students.order(grade: :desc)
    end
  end

  def update
    sibling = current_user.students.find(params[:sib_id])
    if sibling.update(sibling_group: params[:sibling_group])
      flash[:notice] = t("notice.update_sibling_group")
    end
    redirect_to sibling_path(params[:id])
  end

  def destroy
    sibling = current_user.students.find(params[:sib_id])
    if sibling.update(sibling_group: SecureRandom.uuid)
      flash[:notice] = t("notice.destroy_sibling_group")
    end
    redirect_to sibling_path(params[:id])
  end

  private

    def sibling_params
      params.permit(:id, :sib_id, :sibling_group)
    end
end
