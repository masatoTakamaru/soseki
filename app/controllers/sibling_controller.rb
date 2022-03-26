require "date"

class SiblingController < ApplicationController

before_action :authenticate_user!

#兄弟姉妹の設定
def show
  @student = current_user.students.find(params[:id])
  student_extraction    #所属クラス・学年による生徒の抽出
end

#兄弟姉妹の更新
def update
  @student = current_user.students.find_by(id: params[:sibling_id])
  @student.sibling_group = params[:sibling_group]
  if @student.save
    flash[:notice] = t("notice.update_sibling_group")
  end
  redirect_to sibling_path(params[:id])
end

#兄弟姉妹設定の消去
def destroy
  @sibling = current_user.students.find_by(id: params[:sibling_id])
  @sibling[:sibling_group] = SecureRandom.uuid
  if @sibling.save
    flash[:notice] = t("notice.destroy_sibling_group")
  end
  redirect_to sibling_path(params[:id])
end


end
