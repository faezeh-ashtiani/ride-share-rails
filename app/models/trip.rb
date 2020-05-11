class Trip < ApplicationRecord
  belongs_to :passenger
  belongs_to :driver
  validates :date, presence: true
  validates :rating, presence: true, numericality: {only_integer: true}
  validates :cost, presence: true, numericality: {only_integer: true}
  
end
