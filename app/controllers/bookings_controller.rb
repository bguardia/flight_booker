class BookingsController < ApplicationController

    def new
        @booking = Booking.new
        @flight = Flight.find_by(id: booking_params[:flight_id])
        booking_params[:passengers].to_i.times do
            @booking.passengers.build
        end
    end

    private
    def booking_params
        params.permit(:flight_id, :passengers)
    end
end
