class AddDriverIdAndPassengerIdToTrips < ActiveRecord::Migration[6.0]
  def change
    add_column :trips, :driver_id, :integer
    add_column :trips, :passenger_id, :integer
  end
end
