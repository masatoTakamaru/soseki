Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  resources :student
  resources :item
  resources :item_master

  get "home/privacy_policy", to: "home#privacy_policy", as: "privacy_policy"
  get "home/contact", to: "home#contact", as: "contact"
  get "home/help", to: "home#help", as:"help"

  get "sheet/account", to: "sheet#account", as: "account"

  get "search/:postal_code" => "search#postal_code"

end
