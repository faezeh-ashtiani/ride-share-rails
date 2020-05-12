require "test_helper"

describe DriversController do
  # Note: If any of these tests have names that conflict with either the requirements or your team's decisions, feel empowered to change the test names. For example, if a given test name says "responds with 404" but your team's decision is to respond with redirect, please change the test name.

  describe "index" do
    it "responds with success when there are many drivers saved" do
      # Arrange
      Driver.create({
        name: "June Bug",
        vin: "UTGFEE6457426GYR",
        available: true
      })
      # Ensure that there is at least one Driver saved
      
      # Act
      get "/drivers"
      # Assert
      must_respond_with :success

    end

    it "responds with success when there are no drivers saved" do
      # Arrange
      # Ensure that there are zero drivers saved
      Driver.all.each do |driver|
        driver.destroy
      end
      # Act
      get "/drivers"
      # Assert
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid driver" do
      # Arrange
      # Ensure that there is a driver saved
      driver = Driver.create({
        name: "June Bug",
        vin: "UTGFEE6457426GYR",
        available: true
      })

      # Act
      get "/drivers/#{driver.id}"

      # Assert
      must_respond_with :success

    end

    it "responds with 404 with an invalid driver id" do
      # Arrange
      # Ensure that there is an id that points to no driver
      invalid_id = -1

      # Act
      get "/drivers/#{invalid_id}"

      # Assert
      must_respond_with :not_found
    end
  end

  describe "new" do
    it "responds with success" do
      Driver.new({
        name: "June Bug",
        vin: "UTGFEE6457426GYR",
        available: true
      })

      get "/drivers/new"

      must_respond_with :success

    end
  end

  describe "create" do
    it "can create a new driver with valid information accurately, and redirect" do
      # Arrange
      # Set up the form data
      driver_hash = {
        driver: {
        name: "June Bug",
        vin: "UTGFEE6457426GYR",
        available: true
      }
    }

      # Act-Assert
      # Ensure that there is a change of 1 in Driver.count
    expect {
      post drivers_path, params: driver_hash
    }.must_differ 'Driver.count', 1
      # Assert
      # Find the newly created Driver, and check that all its attributes match what was given in the form data
      # Check that the controller redirected the user
    must_redirect_to drivers_path
    driver = Driver.find_by(name: "June Bug")
    expect(driver.name).must_equal driver_hash[:driver][:name]
    expect(driver.vin).must_equal driver_hash[:driver][:vin]
    expect(driver.available).must_equal driver_hash[:driver][:available]


    end

    it "defaults to driver available when created" do
      # Arrange
      # Set up the form data
      driver_hash = {
        driver: {
        name: "June Bug",
        vin: "UTGFEE6457426GYR"
        }
      }

      # Act
      expect {
        post drivers_path, params: driver_hash
      }.must_differ 'Driver.count', 1
  
      # Assert
      expect(Driver.last.available).must_equal true

    end

    it "does not create a driver if the form data violates Driver validations, and responds with bad_request" do
      # Arrange
      driver_hash = {
        driver: {
        name: "June Bug",
        vin: "UTGFEE6457426GYR"
        }
      }
      # Set up the form data so that it violates Driver validations
      driver_hash[:driver][:name] = nil
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        post drivers_path, params: driver_hash
      }.must_differ "Driver.count", 0
      # Assert
      # Check that the controller renders bad_request
      must_respond_with :bad_request
    end
  end
  
  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid driver" do
      # Arrange
      # Ensure there is an existing driver saved
      driver = Driver.create({
        name: "June Bug",
        vin: "UTGFEE6457426GYR",
        available: true
      })

      driver_id = Driver.find_by(name: "June Bug").id

      # Act
      get "/drivers/#{driver_id}/edit"
      
      # Assert
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing driver" do
      # Arrange
      # Ensure there is an invalid id that points to no driver
      invalid_id = -1
      # Act
      get "/drivers/#{invalid_id}/edit"
      # Assert
      must_respond_with :not_found
    end
  end

  describe "update" do
    it "can update an existing driver with valid information accurately, and redirect" do
      # Arrange
      # Ensure there is an existing driver saved
      # Assign the existing driver's id to a local variable
      # Set up the form data
      driver = Driver.create({
        name: "June Bug",
        vin: "UTGFEE6457426GYR",
        available: true
      })

      driver_id = Driver.find_by(name: "June Bug").id

      driver_hash = {
        driver: {
        name: "Driver June Bug",
        vin: "UTGFEE6457426GYR"
        }
      }

      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        patch driver_path(driver_id), params: driver_hash
      }.wont_change "Driver.count"

      # Assert
      # Use the local variable of an existing driver's id to find the driver again, and check that its attributes are updated
      driver = Driver.find_by(id: driver_id)
      expect(driver.name).must_equal driver_hash[:driver][:name]
      expect(driver.vin).must_equal driver_hash[:driver][:vin]

      # Check that the controller redirected the user
      must_redirect_to driver_path(driver_id)
    end

    it "does not update any driver if given an invalid id, and responds with a 404" do
      # Arrange
      # Ensure there is an invalid id that points to no driver
      invalid_id = -1
      # Set up the form data
      driver_hash = {
        driver: {
        name: "Driver June Bug",
        vin: "UTGFEE6457426GYR"
        }
      }

      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        patch driver_path(invalid_id), params: driver_hash
      }.wont_change "Driver.count"

      # Assert
      # Check that the controller gave back a 404
      must_respond_with :not_found
    end

    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Ensure there is an existing driver saved
      # Assign the existing driver's id to a local variable
      # Set up the form data so that it violates Driver validations
      driver = Driver.create({
        name: "June Bug",
        vin: "UTGFEE6457426GYR",
        available: true
      })

      driver_id = Driver.find_by(name: "June Bug").id

      driver_hash = {
        driver: {
        name: "June Bug",
        vin: "UTGFEE6457426GYR"
        }
      }
      driver_hash[:driver][:name] = nil
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        patch driver_path(driver_id), params: driver_hash
      }.wont_change "Driver.count"

      # Assert
      # Check that the controller redirects
      must_respond_with :bad_request
    end
  end

  describe "destroy" do
    it "destroys the driver instance in db when driver exists, then redirects" do
      # Arrange
      # Ensure there is an existing driver saved
      driver = Driver.create({
        name: "June Bug",
        vin: "UTGFEE6457426GYR",
        available: true
      })
      
      driver_id = Driver.find_by(name: "June Bug").id

      # Act-Assert
      # Ensure that there is a change of -1 in Driver.count
      expect {
        delete driver_path(driver_id)
      }.must_differ "Driver.count", -1

      # Assert
      # Check that the controller redirects
      must_redirect_to drivers_path
    end

    it "does not change the db when the driver does not exist, then responds with " do
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
