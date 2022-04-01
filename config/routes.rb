Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  resources :student
  resources :item
  resources :item_master, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :sibling, only: [:show, :update, :destroy]

  get "home/index"
  get "item/dashboard", to: "item#dashboard", as: "dashboard"
  get "home/privacy_policy", to: "home#privacy_policy", as: "privacy_policy"
  get "home/contact", to: "home#contact", as: "contact"
  get "home/help", to: "home#help", as:"help"

  get "home/account", to: "home#account", as: "account"

  get "search/:postal_code", to: "search#postal_code"

end
