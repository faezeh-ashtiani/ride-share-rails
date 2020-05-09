class DriversController < ApplicationController
  def index
    @drivers = Driver.all
  end

  def show
    id = params[:id].to_i
    # @book = Book.find(id) #this returns a Record not fount instead of a nil for an invalid id
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

  private

  def driver_params
    return params.require(:driver).permit(:name, :vin, available: true)
  end

end
