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

end
