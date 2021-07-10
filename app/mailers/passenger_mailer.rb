class PassengerMailer < ApplicationMailer

    def thank_you_email(passenger, booking)
        @passenger = passenger
        @booking = booking
        mail to: @passenger.email,
             subject: "Thank you for your booking!"
    end
end
