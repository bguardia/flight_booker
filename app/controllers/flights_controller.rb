class FlightsController < ApplicationController

    def index
        if flight_params.empty?
            @flights = Flight.all
        else
            if flight_params[:departure] == ""
                depart_day = DateTime.current
            else
                year = flight_params[:departure][/\d{4}(?=-)/].to_i
                month = flight_params[:departure][/(?<=\d{4}-)\d{2}/].to_i
                day = flight_params[:departure][/(?<=-)\d{1,2}\Z/].to_i
                depart_day = DateTime.new(year, month, day)
            end
            @flights = Flight.all.where("to_airport_id = :to AND from_airport_id = :from AND departure_time >= :depart_day_start AND departure_time <= :depart_day_end",
                                        {to: flight_params[:to], 
                                         from: flight_params[:from],
                                         depart_day_start: depart_day.beginning_of_day, 
                                         depart_day_end: depart_day.end_of_day})
        end
        @airports = Airport.all
        @num_passengers = flight_params.fetch(:passengers, 0)
    end

    private
    def flight_params
        params.permit(:to, :from, :departure, :passengers)
    end
end
