class DriversController < ApplicationController
  def index
    @drivers = Driver.all.page(params[:page])
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
      render :new, status: :bad_request
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
      render :edit, status: :bad_request
      return
    end
  end

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
    default_params_hash = {available: true}
    permitted_params = params.require(:driver).permit(
      :name,
      :vin,
      :available
    )
    return default_params_hash.merge(permitted_params)
  end

end
