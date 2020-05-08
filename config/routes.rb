Rails.application.routes.draw do
  root to: "sessions#new"

  get "updates" => "messages#updates"

  resources :users
  resources :games, only: [:new, :destroy, :show] do
    get :join, on: :member
    get :waiting, on: :collection
  end

  resource :session, only: [:new, :create, :destroy]
end
