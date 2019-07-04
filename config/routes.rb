Rails.application.routes.draw do
  resources :rooms
  resources :buildings
  resources :users

  root 'static_pages#home'
  get '/about', to: 'static_pages#about'

  get '/signup', to: 'users#new'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
