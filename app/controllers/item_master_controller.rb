class ItemMasterController < ApplicationController

  include ApplicationHelper
  before_action :authenticate_user!

  def index
    @item_masters = current_user.item_masters
  end

end
