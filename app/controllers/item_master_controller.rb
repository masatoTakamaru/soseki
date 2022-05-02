class ItemMasterController < ApplicationController

  include ApplicationHelper
  before_action :authenticate_user!

  def index
    @item_master = current_user.item_masters.order(:code)
  end

  def new
    if current_user.item_masters.count >= @item_limit
      flash[:notice] = t("notice.item_overlimit")
      redirect_to item_master_index_path
    end
    @item_master = ItemMaster.new
  end

  def create
    redirect_to item_master_index_path if current_user.item_masters.count >= @item_limit
    @item_master = current_user.item_masters.new(item_master_params)
    if @item_master.save
      flash[:notice] = t("notice.new_itemmaster_create")
      redirect_to item_master_index_path
    else
      render new_item_master_path
    end
  end

  def edit
    @item_master = current_user.item_masters.find_by_hashid(params[:id])
  end

  def update
    @item_master = current_user.item_masters.find_by_hashid(params[:id])
    if @item_master.update(item_master_params)
      flash[:notice] = t("notice.itemmaster_update")
      redirect_to item_master_index_path
    else
      render edit_item_master_path
    end
  end

  def destroy
    @item_master = current_user.item_masters.find_by_hashid(params[:id])
    @item_master.destroy
    flash[:notice] = t("notice.itemmaster_destroy")
    redirect_to item_master_index_path
  end

  private

    def item_master_params
      params.require(:item_master).permit(
        :category, :name, :price, :description, :code)
    end


end
