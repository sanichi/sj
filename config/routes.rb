Rails.application.routes.draw do
  root to: "sessions#new"

  get "play" => "pages#play"
  get "updates" => "messages#updates"

  resources :users

  resource :session, only: [:new, :create, :destroy]
end
