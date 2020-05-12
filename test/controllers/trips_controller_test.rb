require "test_helper"

describe TripsController do
  before do
    @driver = Driver.create(
      {
        name: "Driver June Bug",
        vin: "UTGFEE6457426GYR",
        available: true
      }
    )
    @passenger = Passenger.create(
      {
        name: "Passenger June Bug",
        phone_num: "206-646-7578"
      }
    )
    @trip = Trip.create(
      {
        date: Date.today,
        rating: 3,
        cost: 1265,
        passenger_id: @passenger.id,
        driver_id: @driver.id
      }
    )
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
      # Ensure that there is a change of 1 in Trip.count
      expect {
        post passenger_trip_path(@passenger.id)
      }.must_differ 'Trip.count', 1
      # Assert
      # Find the newly created Trip, and check that all its attributes match what was given in the form data
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
      # driver = Driver.available_driver
      # puts driver
      # an array of all the avalable drivers


      #make trip with forcing in our new driver  
      expect {
        post passenger_trip_path(@passenger.id)
      }.must_differ 'Trip.count', 1
      # puts Driver.find_by(id: Trip.last.driver_id) #trip is not assigning our prev driver
      # puts driver.available
      driver = Driver.find_by(id: Trip.last.driver_id)
      # test that driver is one of the drivers from the array (shows that it was available)
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
    it "responds with success when getting the edit page for an existing, valid trip" do
      # Arrange
      # Ensure there is an existing trip saved
      trip_id = Trip.last.id
  
      # Act
      get "/trips/#{trip_id}/edit"
      
      # Assert
      must_respond_with :success
    end
  
    it "responds with redirect when getting the edit page for a non-existing trip" do
      # Arrange
      # Ensure there is an invalid id that points to no trip
      invalid_id = -1
      # Act
      get "/trips/#{invalid_id}/edit"
      # Assert
      must_respond_with :not_found
    end

  end

  describe "update" do
    it "can update an existing trip with valid information accurately, and redirect" do
      # Arrange
      # Ensure there is an existing trip saved
      # Assign the existing trip's id to a local variable
      # Set up the form data
      trip_id = Trip.last.id

      driver_2 = Driver.create({
        name: "Faezeh Ashtiani",
        vin: "YTREWDFGHGFDSDF",
        available: true
      })
  
      trip_hash = {
        trip: {
          rating: 3,
          cost: 1500,
          driver_id: driver_2.id
        }
      }
  
      # Act-Assert
      # Ensure that there is no change in Trip.count
      expect {
        patch trip_path(trip_id), params: trip_hash
      }.wont_change "Trip.count"
  
      # Assert
      # Use the local variable of an existing trip's id to find the trip again, and check that its attributes are updated
      trip = Trip.find_by(id: trip_id)
      expect(trip.rating).must_equal trip_hash[:trip][:rating]
      expect(trip.cost).must_equal trip_hash[:trip][:cost]
  
      # Check that the controller redirected the user
      must_redirect_to trip_path(trip_id)
    end
  
    it "does not update any trip if given an invalid id, and responds with a 404" do
      # Arrange
      # Ensure there is an invalid id that points to no trip
      invalid_id = -1
      # Set up the form data
      trip_hash = {
        trip: {
          rating: 3,
          cost: 1500,
          driver_id: @driver.id
        }
      }
  
      # Act-Assert
      # Ensure that there is no change in Trip.count
      expect {
        patch trip_path(invalid_id), params: trip_hash
      }.wont_change "Trip.count"
  
      # Assert
      # Check that the controller gave back a 404
      must_respond_with :not_found
    end
  
    it "does not create a trip if the form data violates Trip validations, and responds with a redirect" do
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Ensure there is an existing trip saved
      # Assign the existing trip's id to a local variable
      # Set up the form data so that it violates trip validations
  
      trip_id = Trip.last.id
  
      trip_hash = {
        trip: {
          rating: 3,
          cost: 1500,
          driver_id: @driver.id
        }
      }
      trip_hash[:trip][:rating] = nil
      # Act-Assert
      # Ensure that there is no change in Trip.count
      expect {
        patch trip_path(trip_id), params: trip_hash
      }.wont_change "Trip.count"
  
      # Assert
      # Check that the controller redirects
      must_respond_with :bad_request
    end
  end

  describe "destroy" do
    it "destroys the trip instance in db when trip exists, then redirects" do
      # Arrange
      # Ensure there is an existing trip saved
      trip_id = Trip.last.id
  
      # Act-Assert
      # Ensure that there is a change of -1 in Trip.count
      expect {
        delete trip_path(trip_id)
      }.must_differ "Trip.count", -1
  
      # Assert
      # Check that the controller redirects
      must_redirect_to root_path
    end
  
    it "does not change the db when the trip does not exist, then responds with a 404 " do
      # Arrange
      # Ensure there is an invalid id that points to no trip
      invalid_id = -1
  
      # Act-Assert
      # Ensure that there is no change in Trip.count
      expect {
        delete trip_path(invalid_id)
      }.wont_change "Trip.count"
  
      # Assert
      # Check that the controller responds or redirects with whatever your group decides
      must_respond_with :not_found
  
    end
  end
end
