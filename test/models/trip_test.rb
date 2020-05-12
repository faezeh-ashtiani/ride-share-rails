require "test_helper"

describe Trip do
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
    @trip = Trip.new(
      {
        date: Date.today,
        rating: 3,
        cost: 1265,
        passenger_id: @passenger.id,
        driver_id: @driver.id
      }
    )
  end

  it "can be instantiated" do
    expect(@trip.valid?).must_equal true
  end

  it "will have the required fields" do
    @trip.save
    trip = Trip.first
    [:date, :rating, :cost].each do |field|

      # Assert
      expect(trip).must_respond_to field
    end
  end

  describe "relationships" do
    it "has one passenger and one driver" do
      @trip.save
      expect(@trip.driver_id).must_equal @driver.id
      expect(@trip.driver).must_be_instance_of Driver
      expect(@trip.passenger_id).must_equal @passenger.id
      expect(@trip.passenger).must_be_instance_of Passenger
    end
  end

  describe "validations" do
    it "must have a date" do
      # Arrange
      @trip.date = nil

      # Assert
      expect(@trip.valid?).must_equal false
      expect(@trip.errors.messages).must_include :date
      expect(@trip.errors.messages[:date]).must_equal ["can't be blank"]
    end

    it "must have a cost and the cost must be an integer" do
      # Arrange
      @trip.cost = nil

      # Assert
      expect(@trip.valid?).must_equal false
      expect(@trip.errors.messages).must_include :cost
      expect(@trip.errors.messages[:cost]).must_equal ["can't be blank", "is not a number"]
    end

    it "must have a rating and the rating must be an integer" do
      # Arrange
      @trip.rating = nil

      # Assert
      expect(@trip.valid?).must_equal false
      expect(@trip.errors.messages).must_include :rating
      expect(@trip.errors.messages[:rating]).must_equal ["can't be blank", "is not a number"]
    end

  end

  # Tests for methods you create should go here
  describe "custom methods" do
    # Your tests here
  end
end
