require "date"

class SiblingController < ApplicationController

  include ApplicationHelper
  before_action :authenticate_user!

  #兄弟姉妹の設定
  def show
    @student = current_user.students.find_by_hashid(params[:id])
    student_extraction    #所属クラス・学年による生徒の抽出
  end

  #兄弟姉妹の更新
  def update
    sibling = current_user.students.find_by_hashid(params[:sibling_id])
    if sibling.update(sibling_group: params[:sibling_group])
      flash[:notice] = t("notice.update_sibling_group")
    end
    redirect_to sibling_path(params[:id])
  end

  #兄弟姉妹設定の消去
  def destroy
    sibling = current_user.students.find_by_hashid(params[:sibling_id])
    if sibling.update(sibling_group: SecureRandom.uuid)
      flash[:notice] = t("notice.destroy_sibling_group")
    end
    redirect_to sibling_path(params[:id])
  end

end
