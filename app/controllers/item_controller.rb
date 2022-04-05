class ItemController < ApplicationController

  @@year = 0
  @@month = 0

  def dashboard
    @students = current_user.students.where(expire_flag: false)
    @item_masters = current_user.item_masters
    @items = current_user.items
  end

  def index
    @@year = params[:year] if params[:year].present?
    @@month = params[:month] if params[:month].present?
    @year = @@year
    @month = @@month
    student_sort
    @item_masters = current_user.item_masters
    @items = current_user.items
  end

  def new
    @student = current_user.students.find_by_hashid(params[:id])
    @item_masters = current_user.item_masters
    @items = current_user.items
  end

end
