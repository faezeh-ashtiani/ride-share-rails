class AddNullabilityToDriverAndPassenger < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :trips, :drivers
    remove_foreign_key :trips, :passengers
    add_foreign_key :trips, :drivers, on_delete: :nullify
    add_foreign_key :trips, :passengers, on_delete: :nullify
  end
end
