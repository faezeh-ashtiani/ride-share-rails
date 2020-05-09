class TripsController < ApplicationController
  def show
    id = params[:id].to_i
    @trip = Trip.find_by(id: id)
    if @trip.nil?
      head :not_found
      return
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
    @Trip = Trip.find_by(id: params[:id])
    if @Trip.nil?
      head :not_found
      return
    elsif @Trip.update(trip_params)
      redirect_to trip_path(@trip.id) 
      return
    else 
      render :edit 
      return
    end
  end

  private

  def trip_params
    return params.require(:trip).permit(
      date: Date.today,
      rating: 0,
      cost: rand(500..9999),
      # :passenger_id,
      # :driver_id
    )
  end

end
