Rails.application.routes.draw do
  devise_for :users
  resources :tweets

  # Defines the root path route ("/")
  root "tweets#index"
end
