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
    # Your tests go here
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
