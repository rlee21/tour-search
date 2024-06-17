# frozen_string_literal: true

# == Schema Information
#
# Table name: tours
#
#  id              :bigint           not null, primary key
#  days            :integer          not null
#  end_city        :string           not null
#  end_date        :date             not null
#  name            :string           not null
#  seats_available :integer
#  seats_booked    :integer
#  seats_maximum   :integer
#  start_city      :string           not null
#  start_date      :date             not null
#  status          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  external_id     :string           not null
#
# Indexes
#
#  index_tours_on_days        (days)
#  index_tours_on_name        (name)
#  index_tours_on_start_date  (start_date)
#  index_tours_on_status      (status)
#  unique_external_ids        (external_id) UNIQUE
#
FactoryBot.define do
  factory :tour do
    external_id { Faker::Lorem.characters(number: 9, min_alpha: 3, min_numeric: 6) }
    name { Faker::Lorem.characters }
    status { Tour.statuses[:active] }
    days { Faker::Number.between(from: 7, to: 14) }
    start_date { Faker::Date.between(from: '2025-01-01', to: '2025-12-31') }
    start_city { Faker::Address.city }
    end_city { Faker::Address.city }
    seats_maximum { 25 }
    seats_booked { 23 }
    seats_available { 2 }

    after(:build) do |tour|
      tour.end_date = tour.start_date + tour.days.days
    end
  end
end
