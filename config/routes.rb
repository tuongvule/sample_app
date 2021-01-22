Rails.application.routes.draw do
  root to: "static_pages#home"
  get "static_pages/help"
  scope "(:locale)", locale: /en|vi/ do
    resources :microposts
    resources :users, except: %i(new create)
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
  end
end
