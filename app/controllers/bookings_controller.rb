class BookingsController < ApplicationController

    def new
        @flight = Flight.find_by(id: booking_params[:flight_id])
        @num_passengers = booking_params[:passengers]
    end

    private
    def booking_params
        params.permit(:flight_id, :passengers)
    end
end
