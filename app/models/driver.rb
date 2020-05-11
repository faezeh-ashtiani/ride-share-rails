class Driver < ApplicationRecord
  has_many :trips
  validates :name, presence: true
  validates :vin, presence: true, uniqueness: true

  def earnings
    (self.trips.sum { |trip| trip.cost / 100 - 1.65 } * 0.8).round(2)
  end

  def rating
    if self.trips.length == 0
      return 0
    else
      (self.trips.sum { |trip| trip.rating.to_f } / self.trips.length).round(2)
    end
  end

  def self.available_driver
    all.select { |driver| driver.available == true }.first
    # Driver.find_by(available: true)
  end
end
