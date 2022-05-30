Rails.application.routes.draw do
  devise_for :users
  resources :streams, :thoughts

  # Defines the root path route ("/")
  root "streams#index"
end
