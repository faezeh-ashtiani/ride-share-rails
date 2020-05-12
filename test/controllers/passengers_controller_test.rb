require "test_helper"

describe PassengersController do
  describe "index" do
    it "responds with success when there are many passengers saved" do
      # Arrange
      Passenger.create({
        name: "June Bug",
        phone_num: "206-646-7578"
      })
      # Ensure that there is at least one passenger saved
      
      # Act
      get "/passengers"
      # Assert
      must_respond_with :success

    end

    it "responds with success when there are no passengers saved" do
      # Arrange
      # Ensure that there are zero passengers saved
      Passenger.all.each do |passenger|
        passenger.destroy
      end
      # Act
      get "/passengers"
      # Assert
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid passenger" do
      # Arrange
      # Ensure that there is a passenger saved
      passenger = Passenger.create({
        name: "June Bug",
        phone_num: "206-646-7578"
      })

      # Act
      get "/passengers/#{passenger.id}"

      # Assert
      must_respond_with :success

    end

    it "responds with 404 with an invalid passenger id" do
      # Arrange
      # Ensure that there is an id that points to no passenger
      invalid_id = -1

      # Act
      get "/passengers/#{invalid_id}"

      # Assert
      must_respond_with :not_found
    end
  end

  describe "new" do
    it "responds with success" do
      Passenger.new({
        name: "June Bug",
        phone_num: "209-823-4034"
      })

      get "/passengers/new"

      must_respond_with :success

    end
  end

  describe "create" do
    it "can create a new passenger with valid information accurately, and redirect" do
      # Arrange
      # Set up the form data
      passenger_hash = {
        passenger: {
        name: "June Bug",
        phone_num: "UTGFEE6457426GYR"
      }
    }

      # Act-Assert
      # Ensure that there is a change of 1 in Driver.count
    expect {
      post passengers_path, params: passenger_hash
    }.must_differ 'Passenger.count', 1
      # Assert
      # Find the newly created Driver, and check that all its attributes match what was given in the form data
      # Check that the controller redirected the user
    must_redirect_to passengers_path
    passenger = Passenger.find_by(name: "June Bug")
    expect(passenger.name).must_equal passenger_hash[:passenger][:name]
    expect(passenger.phone_num).must_equal passenger_hash[:passenger][:phone_num]
    end

    it "does not create a passenger if the form data violates Passenger validations, and responds with bad_request" do
      # Arrange
      passenger_hash = {
        passenger: {
        name: "June Bug",
        phone_num: "209-823-4034"
        }
      }
      # Set up the form data so that it violates Driver validations
      passenger_hash[:passenger][:name] = nil
      # Act-Assert
      # Ensure that there is no change in Passenger.count
      expect {
        post passengers_path, params: passenger_hash
      }.must_differ "Passenger.count", 0
      # Assert
      # Check that the controller renders bad_request
      must_respond_with :bad_request
    end

  end

  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid passenger" do
      # Arrange
      # Ensure there is an existing passenger saved
      passenger = Passenger.create({
        name: "June Bug",
        phone_num: "209-823-4034"
      })

      passenger_id = Passenger.find_by(name: "June Bug").id

      # Act
      get "/passengers/#{passenger_id}/edit"
      
      # Assert
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing passenger" do
      # Arrange
      # Ensure there is an invalid id that points to no passenger
      invalid_id = -1
      # Act
      get "/passengers/#{invalid_id}/edit"
      # Assert
      must_respond_with :not_found
    end
  end

  describe "update" do
    it "can update an existing passenger with valid information accurately, and redirect" do
      # Arrange
      # Ensure there is an existing passenger saved
      # Assign the existing passenger's id to a local variable
      # Set up the form data
      passenger = Passenger.create({
        name: "June Bug",
        phone_num: "209-823-4034"
      })

      passenger_id = Passenger.find_by(name: "June Bug").id

      passenger_hash = {
        passenger: {
        name: "Passenger June Bug",
        phone_num: "209-823-4034"
        }
      }

      # Act-Assert
      # Ensure that there is no change in Passenger.count
      expect {
        patch passenger_path(passenger_id), params: passenger_hash
      }.wont_change "Passenger.count"

      # Assert
      # Use the local variable of an existing passenger's id to find the passengers again, and check that its attributes are updated
      passenger = Passenger.find_by(id: passenger_id)
      expect(passenger.name).must_equal passenger_hash[:passenger][:name]
      expect(passenger.phone_num).must_equal passenger_hash[:passenger][:phone_num]

      # Check that the controller redirected the user
      must_redirect_to passenger_path(passenger_id)
    end

    it "does not update any passenger if given an invalid id, and responds with a 404" do
      # Arrange
      # Ensure there is an invalid id that points to no passenger
      invalid_id = -1
      # Set up the form data
      passenger_hash = {
        passenger: {
        name: "Passenger June Bug",
        phone_num: "209-823-4034"
        }
      }

      # Act-Assert
      # Ensure that there is no change in Passenger.count
      expect {
        patch passenger_path(invalid_id), params: passenger_hash
      }.wont_change "Passenger.count"

      # Assert
      # Check that the controller gave back a 404
      must_respond_with :not_found
    end

    it "does not create a passenger if the form data violates Passenger validations, and responds with a redirect" do
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Ensure there is an existing passenger saved
      # Assign the existing passenger's id to a local variable
      # Set up the form data so that it violates Passenger's validations
      passenger = Passenger.create({
        name: "June Bug",
        phone_num: "209-823-4034"
      })

      passenger_id = Passenger.find_by(name: "June Bug").id

      passenger_hash = {
        passenger: {
        name: "June Bug",
        phone_num: "209-823-4034"
        }
      }
      passenger_hash[:passenger][:name] = nil
      # Act-Assert
      # Ensure that there is no change in Passenger.count
      expect {
        patch passenger_path(passenger_id), params: passenger_hash
      }.wont_change "Passenger.count"

      # Assert
      # Check that the controller redirects
      must_respond_with :bad_request
    end
  end

  describe "destroy" do
    it "destroys the passenger instance in db when passenger exists, then redirects" do
      # Arrange
      # Ensure there is an existing passenger saved
      passenger = Passenger.create({
        name: "June Bug",
        phone_num: "209-823-4034"
      })
      
      passenger_id = Passenger.find_by(name: "June Bug").id

      # Act-Assert
      # Ensure that there is a change of -1 in Driver.count
      expect {
        delete passenger_path(passenger_id)
      }.must_differ "Passenger.count", -1

      # Assert
      # Check that the controller redirects
      must_redirect_to passengers_path
    end

    it "does not change the db when the passenger does not exist, then responds with not_found" do
      # Arrange
      # Ensure there is an invalid id that points to no driver
      invalid_id = -1

      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        delete driver_path(invalid_id)
      }.wont_change "Driver.count"

      # Assert
      # Check that the controller responds or redirects with whatever your group decides
      must_respond_with :not_found

    end
  end
end
