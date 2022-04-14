class QtyPriceController < ApplicationController

  include ApplicationHelper
  before_action :authenticate_user!

  def edit
    #価格が登録されていない場合初期化
    if current_user.qty_prices.empty?
      1.upto(12){|num|
        current_user.qty_prices.create(qty: num, price: 0)
      }
    end
    @prices = current_user.qty_prices.order(qty: :asc).pluck(:price)
  end

  def update
    flag = true
    1.upto(12){|num|
      price = current_user.qty_prices.find_by(qty: num)
      unless params[:prices][num-1] =~ /\A[0-9]+\.?[0-9]*\z/
        flag = false
      end
      unless price.update(price: params[:prices][num-1])
        flag = false
      end
    }
    if flag
      flash[:notice] = "価格を更新しました。"
    else
      flash[:notice] = "更新が失敗しました。価格は0以上の値を入力して下さい。"
    end
    redirect_to qty_price_edit_path
  end

end
