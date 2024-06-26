Rails.application.routes.draw do
  root to: "sessions#new"

  %w/push pull/.each { |a| get a => "messages##{a}" }
  get "env" => "pages#env"

  resources :users do
    get :scores, on: :member
  end
  resources :games, only: [:new, :create, :destroy, :show, :index] do
    get :join, on: :member
    get :play, on: :member
    get :waiting, on: :collection
    get :refresh, on: :collection
  end

  resource :session, only: [:new, :create, :destroy]
end
