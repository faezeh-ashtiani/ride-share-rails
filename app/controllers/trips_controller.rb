class TripsController < ApplicationController
  def show
    id = params[:id].to_i
    @trip = Trip.find_by(id: id)
    if @trip.nil?
      head :not_found
      return
    end
  end
  
  def passenger_trip
    # raise
    @trip = Trip.new(
      date: Date.today.to_date,
      rating: 0,
      cost: rand(500..9999),   
      passenger_id: params[:passenger_id],
      driver_id: Driver.available_driver.id
    )
    if @trip.save
      redirect_to trip_path(@trip.id)
    else
      head :bad_request
    end
  end 

  def edit
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      head :not_found
      return
    end
  end

  def update
    # raise
    @trip = Trip.find_by(id: params[:id])
    params = trip_params
    if @trip.nil?
      head :not_found
      return
    elsif @trip.update(trip_params)
      redirect_to trip_path(@trip.id) 
      return
    else 
      render :edit 
      return
    end
  end

  private

  def trip_params
    default_params_hash = {
      date: Date.today,
      rating: 0,
      cost: rand(500..9999)
    }
    permitted_params = params.require(:trip).permit(
      :date,
      :rating,
      :cost,
      :passenger_id,
      :driver_id
    )
    return default_params_hash.merge(permitted_params)
  end

end
