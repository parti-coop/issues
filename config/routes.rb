Rails.application.routes.draw do
  root "articles#index"

  devise_for :users

  resources :articles
  resources :users

  if Rails.env.development?
    require 'sidekiq/web'
    require 'sidekiq/cron/web'
    mount Sidekiq::Web => '/sidekiq'
  end
end
