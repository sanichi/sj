Rails.application.routes.draw do
  root to: "sessions#new"

  get "play" => "pages#play"
  get "ping" => "messages#ping"

  resources :users

  resource :session, only: [:new, :create, :destroy]
end
