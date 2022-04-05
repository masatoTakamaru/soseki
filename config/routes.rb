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

  get "item/dashboard", to: "item#dashboard", as: "dashboard"
  get "item/index", to: "item#index", as: "item_index"
  get "item/:id/new", to: "item#new", as: "new_item"

  patch "student/:id/expire", to: "student#expire", as: "student_expire"
  patch "student/:id/expire_cancel", to: "student#expire_cancel", as: "student_expire_cancel"
  get "student/expired", to: "student#expired", as: "student_expired"
  resources :student

  get "search/:postal_code", to: "search#postal_code", as: "search_postal_code"

end
