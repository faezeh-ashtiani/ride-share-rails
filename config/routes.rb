Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  root to: 'homepages#index'
  
  resources :passengers
  resources :drivers
  resources :trips, except: [:index]

  post '/trips/:passenger_id', to: 'trips#passenger_trip', as: 'passenger_trip'
end
