Rails.application.routes.draw do
  devise_for :users

  resources :tags
  resources :articles do
    put :vote, on: :member
  end
  resources :wikis
  resources :users
  resources :comments, only: [:create, :destroy]

  get 'pages/about', as: 'about'

  root "articles#index"

  if Rails.env.development?
    require 'sidekiq/web'
    require 'sidekiq/cron/web'
    mount Sidekiq::Web => '/sidekiq'
  end
end
