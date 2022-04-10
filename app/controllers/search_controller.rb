class SearchController < ApplicationController

  include ApplicationHelper
  before_action :authenticate_user!

  #郵便番号から住所を検索するAPI
  def postal_code
    @postal_code = Postal.find_by(postal_code:params[:postal_code])
    render json: @postal_code
  end
end
