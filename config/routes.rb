Rails.application.routes.draw do

  resources :bookings, only: [:index, :show, :new, :create, :destroy]

  get '/rooms/real_state', to: 'rooms#real_state'
  get '/rooms/busy_without_booking', to: 'rooms#busy_without_booking'

  resources :rooms
  resources :buildings
  resources :users

  get '/stats/top_five', to: 'stats#top_five'
  get '/stats/averages', to: 'stats#averages'
  get '/stats/rooms_bookings_by_day', to: 'stats#rooms_bookings_by_day'
  get '/stats/rooms_bookings_by_hour', to: 'stats#rooms_bookings_by_hour'

  root 'static_pages#home'
  get '/about', to: 'static_pages#about'

  get '/signup', to: 'users#new'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
