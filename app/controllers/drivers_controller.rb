class DriversController < ApplicationController
  def index
    @drivers = Driver.all
  end

  def show
    id = params[:id].to_i
    @driver = Driver.find_by(id: id)
    if @driver.nil?
      head :not_found
      return
    end
  end

  def new
    @driver = Driver.new
  end

  def create
    @driver = Driver.new(driver_params)
    if @driver.save
      redirect_to drivers_path
    else
      render :new
    end
  end

  def edit
    @driver = Driver.find_by(id: params[:id])

    if @driver.nil?
      head :not_found
      return
    end
  end

  def update
    @driver = Driver.find_by(id: params[:id])
    if @driver.nil?
      head :not_found
      return
    elsif @driver.update(driver_params)
      redirect_to driver_path(@driver.id) 
      return
    else 
      render :edit 
      return
    end
  end

  # def mark_unavailable
  #   @driver = Driver.find_by(id: params[:id])
  #   if @driver.nil?
  #     head :not_found
  #     return
  #   elsif @driver.update(driver_params.merge({available: false}))
  #     redirect_to trip_path(@driver.trips.last.id)
  #     return
  #   else 
  #     render :edit 
  #     return
  #   end

  # end

  def destroy
    id = params[:id].to_i
    @driver = Driver.find_by(id: id)

    if @driver.nil?
      head :not_found
      return
    end
    
    @driver.destroy
    redirect_to drivers_path 
    return
  end 

  private

  def driver_params
    return params.require(:driver).permit(:name, :vin, available: true)
  end

end
