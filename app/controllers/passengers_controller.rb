class PassengersController < ApplicationController
  def index
    @passengers = Passenger.all
  end

  def show 
    passenger_id = params[:id]
    @passenger = Passenger.find_by(id: passenger_id)
    if @passenger.nil?
      head :not_found
      return
    end
  end 

  def new

  end 


  def create

  end

  
  def edit 

  end 

  def update

  end 

  def destroy

  end 
end
