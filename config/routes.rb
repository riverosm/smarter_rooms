Rails.application.routes.draw do

  resources :bookings, only: [:index, :show, :new, :create]

  get '/rooms/real_state', to: 'rooms#real_state'
  get '/rooms/busy_without_booking', to: 'rooms#busy_without_booking'

  resources :rooms
  resources :buildings
  resources :users

  get '/stats', to: 'stats#home'

  root 'static_pages#home'
  get '/about', to: 'static_pages#about'

  get '/signup', to: 'users#new'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
