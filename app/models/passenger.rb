class Passenger < ApplicationRecord
  has_many :trips
  validates :name, presence: true, uniqueness: true
  validates :phone_num, presence: true, length: {minimum: 10} #must contain 10 letters 

  def total_cost
    (self.trips.sum {|trip| trip.cost.to_f}) / 100
  end
end
