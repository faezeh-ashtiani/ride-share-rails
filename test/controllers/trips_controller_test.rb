require "test_helper"

describe TripsController do
  before do
    @driver = Driver.create({
      name: "Driver June Bug",
      vin: "UTGFEE6457426GYR",
      available: true
    })
    @passenger = Passenger.create({
      name: "Passenger June Bug",
      phone_num: "206-646-7578"
    })
    @trip = Trip.create({
      date: Date.today,
      rating: 3,
      cost: 1265,
      passenger_id: @passenger.id,
      driver_id: @driver.id
    })
  end
  describe "show" do
    it "responds with success when showing an existing valid trip" do
      # Arrange
      # Ensure that there is a trip saved
      
      # Act
      get "/trips/#{@trip.id}"

      # Assert
      must_respond_with :success

    end

    it "responds with 404 with an invalid trip id" do
      # Arrange
      # Ensure that there is an id that points to no trip
      invalid_id = -1

      # Act
      get "/trips/#{invalid_id}"

      # Assert
      must_respond_with :not_found
    end
  end

  describe "create" do
    # Your tests go here
  end

  describe "edit" do
    # Your tests go here
  end

  describe "update" do
    # Your tests go here
  end

  describe "destroy" do
    # Your tests go here
  end
end
