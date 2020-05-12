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
    
    driver = Driver.available_driver
    if !driver.nil?
      @trip = Trip.new(
        date: Date.today.to_date,
        rating: 0,
        cost: rand(500..9999),   
        passenger_id: params[:passenger_id],
        driver_id: driver.id
      )
      if @trip.save
        trip_driver = Driver.find_by(id: @trip.driver_id)
        trip_driver.update(available: false)
        # check the update if an if statement
        redirect_to trip_path(@trip.id)
      else
        head :bad_request
      end
    else
      redirect_to passenger_path(params[:passenger_id])
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
      render :edit, status: :bad_request
      return
    end
  end

  def destroy
    id = params[:id].to_i
    @trip = Trip.find_by(id: id)

    if @trip.nil?
      head :not_found
      return
    end
    
    @trip.destroy
    redirect_to root_path 
    return
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
