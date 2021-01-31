Rails.application.routes.draw do
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  root to: "static_pages#home"
  get "static_pages/help"
  scope "(:locale)", locale: /en|vi/ do
    resources :microposts
    resources :users

  end

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users, only: %i(new create)
  resources :account_activations, only: :edit
end
