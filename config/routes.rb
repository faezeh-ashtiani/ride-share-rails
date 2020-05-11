Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  root to: 'homepages#index'
  # patch '/drivers/:id/mark_unavailable', to: 'drivers#mark_unavailable', as: 'mark_unavailable'

  resources :passengers
  resources :drivers
  resources :trips, except: [:index, :new, :create]

  # patch '/drivers/:id/mark_unavailable', to: 'drivers#mark_unavailable', as: 'mark_unavailable'
  post '/trips/:passenger_id', to: 'trips#passenger_trip', as: 'passenger_trip'
end
