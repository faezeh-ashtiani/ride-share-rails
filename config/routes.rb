Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  root to: 'homepages#index'
  
  ## Passenger seeds
  get '/passengers', to: 'passengers#index', as: 'passengers' 
  
  
  # Add Routes that have to do with collection of passengers
  get '/passengers/new', to: 'passengers#new', as: 'new_passenger' #gets a form for new passenger
  post '/passengers', to: 'passengers#create' #dont nn to make nickname bc path is the same as /passenger
  
  
  #Routes that deal with specific passenger 
  get '/passengers/:id', to: 'passengers#show', as: 'passenger' # shows details for one passenger
  get '/passengers/:id/edit', to: 'passengers#edit', as: 'edit_passenger' #brings up form to edit a passenger
  patch '/passengers/:id', to: 'passengers#update' #send the update form
  delete '/passengers/:id', to: 'passengers#destroy' #deleted passenger
  
  #custom routes - making a passenger as read 
  # patch '/passengers/:id/mark_read', to: 'passengers#mark_read', as: 'passenger_read' #making up new extension is ok 
  ## would nn to make view with touch app/views/passengers/mark_read.html.erb

  resources :drivers
end
