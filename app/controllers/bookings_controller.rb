class BookingsController < ApplicationController

    def show
        @booking = Booking.find_by(id: params[:id])
        @flight = Flight.find_by(id: @booking.flight_id)
    end

    def new
        @booking = Booking.new
        @flight = Flight.find_by(id: params[:flight_id])
        params[:num_passengers].to_i.times do
            @booking.passengers.build
        end
    end

    def create
        @flight = Flight.find_by(id: booking_params[:flight_id])
        @booking = Booking.create(flight_id: @flight.id)
        booking_params[:passengers_attributes].each_value do |passenger_data|
            passenger = @booking.passengers.create(passenger_data)
            PassengerMailer.thank_you_email(passenger, @booking).deliver_later
        end
        flash.now[:notice] = "Your booking has been successfully created!"
        render "show"
        
    end

    private
    def booking_params
        params.require(:booking).permit(:flight_id, passengers_attributes: [:name, :email])
    end
end
