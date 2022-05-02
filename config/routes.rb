Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  resources :item_master, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :sibling, only: [:show, :update, :destroy]

  get "home/account", to: "home#account", as: "account"
  get "home/contact", to: "home#contact", as: "contact"
  get "home/help", to: "home#help", as:"help"
  get "home/index"
  get "home/privacy_policy", to: "home#privacy_policy", as: "privacy_policy"
  get "home/students_csv_download", to: "home#students_csv_download", as: "students_csv_download"
  get "home/expired_csv_download", to: "home#expired_csv_download", as: "expired_csv_download"
  get "home/item_master_csv_download", to: "home#item_master_csv_download", as: "item_master_csv_download"
  get "home/item_csv_download", to: "home#item_csv_download", as: "item_csv_download"

  get "qty_price/before_edit", to: "qty_price#before_edit", as: "qty_price_before_edit"
  get "qty_price/:grade/edit", to: "qty_price#edit", as: "qty_price_edit"
  patch "qty_price/:grade/update", to: "qty_price#update", as: "qty_price_update"

  get "item", to: "item#dashboard"
  delete "item/:id/destroy_item", to: "item#destroy_item", as: "destroy_item"
  delete "item/destroy_bill", to: "item#destroy_bill", as: "destroy_bill"
  get "item/dashboard", to: "item#dashboard", as: "dashboard"
  get "item/before_sheet", to: "item#before_sheet", as: "item_before_sheet"
  get "item/:year/:month/sheet", to: "item#sheet", as: "item_sheet"
  get "item/:student_id/:year/:month/bill", to: "item#bill", as: "item_bill"
  post "item/create", to: "item#create", as: "create_item"

  patch "student/:id/expire", to: "student#expire", as: "student_expire"
  patch "student/:id/expire_cancel", to: "student#expire_cancel", as: "student_expire_cancel"
  get "student/expired", to: "student#expired", as: "student_expired"
  resources :student
  patch "student/promote/:include", to: "student#promote", as: "student_promote"

  get "search/:postal_code", to: "search#postal_code", as: "search_postal_code"

end
1