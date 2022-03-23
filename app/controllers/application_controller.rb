class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?

  def initialize

    super

    #学年の定義
    @grades = [
      "未就学", "年少", "年中", "年長",
      "小学１年", "小学２年", "小学３年",
      "小学４年", "小学５年", "小学６年",
      "中学１年", "中学２年", "中学３年",
      "高校１年", "高校２年", "高校３年",
      "既卒"
    ]

    #アプリ名
    @app_name = "Soseki"

  end


  protected


  def configure_permitted_parameters
    # deviseのstrongparameter
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

end
