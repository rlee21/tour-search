# frozen_string_literal: true

departures_seed_file = Rails.root.join('db/seed_data/departures.json')
departures = JSON.parse(departures_seed_file.read)

departures.each do |departure|
  external_id = departure.keys.first
  status = departure[external_id]['status']

  Tour.find_or_create_by!(external_id: external_id,
                          name: departure[external_id]['name'],
                          days: departure[external_id]['days'],
                          start_date: departure[external_id]['start_date'],
                          end_date: departure[external_id]['end_date'],
                          start_city: departure[external_id]['start_city'],
                          end_city: departure[external_id]['end_city'],
                          seats_available: departure[external_id]['seats_available'],
                          seats_booked: departure[external_id]['seats_booked'],
                          seats_maximum: departure[external_id]['seats_maximum'],
                          status: Tour.statuses[status])
end
