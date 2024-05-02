Rails.application.routes.draw do
  devise_for :users
  resources :tweets

  get "users/:user_id/tweets", to: "tweets#user_index", as: "user_tweets"

  # Defines the root path route ("/")
  root "tweets#index"
end
