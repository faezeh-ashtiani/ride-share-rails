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

  describe "passenger_trip" do

    it "can create a new trip with valid information accurately, and redirect" do
      # Arrange
      # Set up the form data
      
      #studied params hash created by this method, but could not get params passed in for test:
      #trip_hash = {passenger_id: @passenger.id}

      # Act-Assert
      # Ensure that there is a change of 1 in Driver.count
      expect {
        post passenger_trip_path(@passenger.id)
      }.must_differ 'Trip.count', 1
      # Assert
      # Find the newly created Driver, and check that all its attributes match what was given in the form data
      # Check that the controller redirected the user
    must_redirect_to trip_path(Trip.last.id)
    
    passenger = Passenger.find_by(id: Trip.last.passenger_id)
    driver = Driver.find_by(id: Trip.last.driver_id)
    expect(passenger.name).must_equal "Passenger June Bug"
    expect(driver.id).wont_be_nil
    expect(Trip.last.cost).must_be :>=, 500
    expect(Trip.last.cost).must_be :<=, 9999
    expect(Trip.last.rating).must_be :>=, 0
    expect(Trip.last.rating).must_be :<=, 5
    expect(Trip.last.date).wont_be_nil
    end
  
    it "assigns available driver & changes drivers status to unavailable" do 
      ### NOT WORKING YET

      #call available driver 
      driver = Driver.available_driver
      puts driver
      #make trip with forcing in our new driver  
      expect {
        post passenger_trip_path(@passenger.id)
      }.must_differ 'Trip.count', 1
      puts Driver.find_by(id: Trip.last.driver_id) #trip is not assigning our prev driver
      puts driver.available
      #check his status to see if he is now unavailable 
      expect(driver.available).must_equal false

    end 

    it "does not create a trip if no driver is available" do 
      Driver.all.each do |driver|
        driver.update(available: false)
      end

      expect {
        post passenger_trip_path(@passenger.id)
      }.must_differ 'Trip.count', 0

      must_redirect_to passenger_path(@passenger.id)
    end 

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
