Rails.application.routes.draw do
  get 'search/search'
  resources :parameters
  get 'home/index'
  root to: 'home#index'
  post 'home/insert_tweet'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
