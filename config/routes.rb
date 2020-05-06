Rails.application.routes.draw do
  root to: "sessions#new"

  get "updates" => "messages#updates"

  resources :users
  resources :games, only: [:index, :destroy] do
    get :play, on: :member
  end

  resource :session, only: [:new, :create, :destroy]
end
