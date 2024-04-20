Rails.application.routes.draw do
  resources :tweets

  # Defines the root path route ("/")
  root "tweets#index"
end
