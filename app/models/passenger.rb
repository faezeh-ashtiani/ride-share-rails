class Passenger < ApplicationRecord
  has_many :trips

  def total_cost
    (self.trips.sum {|trip| trip.cost}) / 100
  end
end
