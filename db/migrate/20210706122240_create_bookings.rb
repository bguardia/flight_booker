class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.bigint :flight_id
      t.timestamps
    end

    add_foreign_key :bookings, :flights
  end
end
