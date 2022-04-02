class ItemController < ApplicationController

  def index
    @students = current_user.students
    @item_masters = current_user.item_masters
    @items = current_user.items
  end

end
