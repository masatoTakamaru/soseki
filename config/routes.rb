Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  resources :student
  resources :item

  get "home/privacy_policy", to: "home#privacy_policy", as: "privacy_policy"
  get "home/contact", to: "home#contact", as: "contact"

  get "sheet/account", to: "sheet#account", as: "account"

end
