# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Initializing airports..."
airports = [{ name: "Narita International Airport", code: "NRT", region: "Tokyo", country: "Japan"},
            { name: "Haneda International Airport", code: "HND", region: "Tokyo", country: "Japan"},
            { name: "Chubu Centrair International Airport", code: "NGO", region: "Nagoya", country: "Japan"},
            { name: "Daniel K. Inouye International Airport", code: "HNL", region: "Honolulu", country: "USA"},
            { name: "Los Angeles International Airport", code: "LAX", region: "Los Angeles", country: "USA"},
            { name: "Seattle Tacoma International Airport", code: "SEA", region: "Seattle", country: "USA"},
            { name: "Detroit International Airport", code: "DTW", region: "Detroit", country: "USA"}]

airports.each do |airport_data|
    Airport.create(airport_data.except(:region, :country))
end
puts "#{Airport.count} airports initialized."

airport_ids = airports.reduce({}) { |sum, part| sum.merge(part[:code] => Airport.find_by(code: part[:code]).id) }

puts "Initializing flights..."

flights = [{number: "JL074", from_airport_id: airport_ids["HND"], to_airport_id: airport_ids["HNL"], departure_time: "21:00", elapsed_time: "7:20", days: ["Tuesday", "Friday"]}, #Tue, Fri. dpt. 21:00 arr. 9:55
           {number: "JL073", from_airport_id: airport_ids["HNL"], to_airport_id: airport_ids["HND"], departure_time: "12:35", elapsed_time: "8:20", days: ["Wednesday", "Saturday"]}, #Wed, Sat. dpt. 12:35 arr. 15:55 (next day)
           {number: "JL016", from_airport_id: airport_ids["HND"], to_airport_id: airport_ids["LAX"], departure_time: "17:24", elapsed_time: "10:00", days: ["Wednesday", "Friday", "Sunday"]},  #Wed, Fri, Sun
           {number: "JL015", from_airport_id: airport_ids["LAX"], to_airport_id: airport_ids["HND"], departure_time: "15:30", elapsed_time: "10:53", days: ["Monday", "Thursday", "Saturday"]},  #Mon, Thur, Sat
           {number: "JL062", from_airport_id: airport_ids["NRT"], to_airport_id: airport_ids["LAX"], departure_time: "17:20", elapsed_time: "10:05", days: ["Monday", "Tuesday", "Thursday"]}, #Mon, Tue, Thurs, Sat
           {number: "JL061", from_airport_id: airport_ids["LAX"], to_airport_id: airport_ids["NRT"], departure_time: "13:20", elapsed_time: "11:23", days: ["Tuesday", "Wednesday", "Friday", "Sunday"]}, #Tue, Wed, Fri, Sun
           {number: "JL068", from_airport_id: airport_ids["NRT"], to_airport_id: airport_ids["SEA"], departure_time: "12:00", elapsed_time: "8:50", days: ["Tuesday", "Thursday", "Saturday"]}, #Tue, Thurs, Sat
           {number: "JL067", from_airport_id: airport_ids["SEA"], to_airport_id: airport_ids["NRT"], departure_time: "12:00", elapsed_time: "9:32" , days: ["Wednesday", "Friday", "Sunday"]}, #Wed, Fri, Sun
           {number: "JL8063", from_airport_id: airport_ids["LAX"], to_airport_id: airport_ids["NGO"], departure_time: "14:25", elapsed_time: "11:45", days: ["Sunday"]}, #Mon 14:25 - 18:25 (local arrival time) 
           {number: "DL95", from_airport_id: airport_ids["DTW"], to_airport_id: airport_ids["NGO"], departure_time: "16:00", elapsed_time: "13:05", days: ["Friday"]}, #Sat 16:00 - 18:35 (local arrival time)
           {number: "DL94", from_airport_id: airport_ids["NGO"], to_airport_id: airport_ids["DTW"], departure_time: "17:00", elapsed_time: "12:00", days: ["Sunday"]}] #Sun 17:00 - +16:20 (local arrival time)

weeks_ahead = 9
current_datetime = DateTime.current.beginning_of_day

puts "Creating flights beginning from #{current_datetime} up to #{weeks_ahead} weeks in the future."

def advance_time(datetime, elapsed_time)
    hour_offset = elapsed_time[/\d{1,2}(?=:)/].to_i
    min_offset = elapsed_time[/(?<=:)\d{2}/].to_i
    datetime.advance(hour: hour_offset, min: min_offset)
end

def get_departure_datetime(current_date, day_of_flight, time_of_flight)
    days_of_the_week = { "Sunday" => 0,
                         "Monday" => 1,
                         "Tuesday" => 2,
                         "Wednesday" => 3,
                         "Thursday" => 4,
                         "Friday" => 5,
                         "Saturday" => 6}

    day_offset = days_of_the_week[day_of_flight] - current_date.wday
    departure_datetime = current_date.advance(day: day_offset)
    advance_time(departure_datetime, time_of_flight)
end


flights.each do |flight_data|
    trimmed_flight_data = flight_data.except(:elapsed_time, :days)
    flight_length = flight_data[:elapsed_time]

    flight_data[:days].each do |flight_day|
        flight_departure_day_time = get_departure_datetime(current_datetime, flight_day, flight_data[:departure_time])
        weeks_ahead.times do |count|
            flight_departure_date = flight_departure_day_time.advance(day: 7 * count)
            Flight.create(trimmed_flight_data.merge(
                departure_time: flight_departure_date,
                arrival_time: advance_time(flight_departure_date, flight_length)
            ))
        end
    end
end

puts "#{Flight.count} flights have been initialized."

