Rails.application.routes.draw do
  devise_for :users
  resources :groups, :thoughts

  # Defines the root path route ("/")
  root "groups#index"
end
