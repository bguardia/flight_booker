class BookingsPassengers < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings_passengers, id: false do |t|
      t.belongs_to :booking
      t.belongs_to :passenger
    end
  end
end
