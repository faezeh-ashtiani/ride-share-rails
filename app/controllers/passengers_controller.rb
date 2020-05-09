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
    @passenger = Passenger.find_by(id: params[:id])

    if @passenger.nil?
      head :not_found
      return
    end
  end

  def update
    @passenger = Passenger.find_by(id: params[:id])
    if @passenger.nil?
      head :not_found
      return
    elsif @passenger.update(
      name: params[:passenger][:name], 
      phone_num: params[:passenger][:phone_num]
    )
      redirect_to passengers_path 
      return
    else 
      render :edit
      return
    end
  end 

  def destroy
    id = params[:id].to_i
    @passenger = Passenger.find_by(id: id)

    if @passenger.nil?
      head :not_found
      return
    end
    
    @passenger.destroy
    redirect_to passenger_path 
    return
  end 
end
