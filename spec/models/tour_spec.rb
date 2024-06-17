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
require 'rails_helper'

RSpec.describe Tour do
  subject(:tour) { build(:tour) }

  describe 'enums' do
    it { is_expected.to define_enum_for(:status).with_prefix(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:external_id) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:days) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }
    it { is_expected.to validate_presence_of(:start_city) }
    it { is_expected.to validate_presence_of(:end_city) }

    it { is_expected.to validate_numericality_of(:days).only_integer.is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:seats_available).only_integer }
    it { is_expected.to validate_numericality_of(:seats_booked).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:seats_maximum).only_integer.is_greater_than(0) }

    context 'when end_date is after start_date' do
      it 'is valid' do
        expect(tour).to be_valid
      end
    end

    context 'when end_date is equal to start_date' do
      it 'is valid' do
        tour.end_date = tour.start_date
        expect(tour).to be_valid
      end
    end

    context 'when end_date is before start_date' do
      it 'is not valid' do
        tour.end_date = tour.start_date - 1.day
        expect(tour).not_to be_valid
        expect(tour.errors[:end_date]).to include('must be equal to or after the start date')
      end
    end

    context 'when seats_available exceeds seats_maximum' do
      it 'is not valid' do
        tour.seats_available = tour.seats_maximum + 1
        expect(tour).not_to be_valid
        expect(tour.errors[:seats_available]).to include('cannot exceed the maximum number of seats')
      end
    end
  end

  describe '#availability' do
    context 'when seats_available is more than 5' do
      let(:seats_available) { 6 }

      it 'returns Available' do
        tour.seats_available = seats_available
        expect(tour.availability).to eq('Available')
      end
    end

    context 'when seats_available is between 1 and 5' do
      let(:seats_available) { 3 }

      it 'returns Limited' do
        tour.seats_available = seats_available
        expect(tour.availability).to eq('Limited')
      end
    end

    context 'when seats_available is 0' do
      let(:seats_available) { 0 }

      it 'returns Sold Out' do
        tour.seats_available = seats_available
        expect(tour.availability).to eq('Sold Out')
      end
    end

    context 'when seats_available is less than 0' do
      let(:seats_available) { -5 }

      it 'returns Sold Out' do
        tour.seats_available = seats_available
        expect(tour.availability).to eq('Sold Out')
      end
    end
  end

  describe 'scopes' do
    before do
      create(:tour, name: 'Tour A', seats_available: 10, status: described_class.statuses[:Active])
      create(:tour, name: 'Tour B', seats_available: 3, status: described_class.statuses[:Active])
      create(:tour, name: 'Tour C', seats_available: 0, status: described_class.statuses[:Active])
      create(:tour, name: 'Tour D', seats_available: 0, status: described_class.statuses[:Inactive])
    end

    context 'when available scope' do
      it 'returns available tours' do
        result = described_class.available.first
        expect(result.name).to eq('Tour A')
      end
    end

    context 'when limited scope' do
      it 'returns limited tours' do
        result = described_class.limited.first
        expect(result.name).to eq('Tour B')
      end
    end

    context 'when sold_out scope' do
      it 'returns sold out tours' do
        result = described_class.sold_out.first
        expect(result.name).to eq('Tour C')
      end
    end

    context 'when active scope' do
      it 'returns active tours' do
        result = described_class.active
        expect(result.pluck(:name).sort).to eq(['Tour A', 'Tour B', 'Tour C'])
      end
    end

    context 'when inactive scope' do
      it 'returns inactive tours' do
        result = described_class.inactive
        expect(result.pluck(:name).sort).to eq(['Tour D'])
      end
    end
  end

  describe '.search' do
    before do
      create(:tour, name: 'Tour A', days: 7, start_date: '2025-10-25', seats_available: 10)
      create(:tour, name: 'Tour B', days: 5, start_date: '2025-11-01', seats_available: 3)
      create(:tour, name: 'Tour C', days: 7, start_date: '2025-10-25', seats_available: 0)
    end

    context 'when searching by name' do
      it 'returns tours matching the name' do
        result = described_class.search(name: 'Tour A')
        expect(result.first.name).to eq('Tour A')
      end
    end

    context 'when searching by days' do
      it 'returns tours matching the number of days' do
        result = described_class.search(days: 5)
        expect(result.first.name).to eq('Tour B')
      end
    end

    context 'when searching by start_date' do
      it 'returns tours matching the start date' do
        result = described_class.search(start_date: '2025-10-25')
        expect(result.first.name).to eq('Tour A')
      end
    end

    context 'when searching by availability' do
      it 'returns tours that are available' do
        result = described_class.search(availability: Tour::AVAILABILITY[:available])
        expect(result.first.name).to eq('Tour A')
      end

      it 'returns tours that are limited' do
        result = described_class.search(availability: Tour::AVAILABILITY[:limited])
        expect(result.first.name).to eq('Tour B')
      end

      it 'returns tours that are sold out' do
        result = described_class.search(availability: Tour::AVAILABILITY[:sold_out])
        expect(result.first.name).to eq('Tour C')
      end
    end

    context 'when searching by multiple parameters' do
      it 'returns tours matching all criteria' do
        result = described_class.search(days: 7, start_date: '2025-10-25')
        expect(result.pluck(:name).sort).to eq(['Tour A', 'Tour C'])
      end
    end

    context 'when no parameters are provided' do
      it 'returns all tours' do
        result = described_class.search({})
        expect(result.pluck(:name).sort).to eq(['Tour A', 'Tour B', 'Tour C'])
      end
    end
  end

  describe '.destinations_all' do
    before do
      create(:tour, name: 'Destination A')
      create(:tour, name: 'Destination B')
      create(:tour, name: 'Destination C')
    end

    it 'returns a list of unique destination names ordered by name' do
      result = described_class.destinations_all
      expect(result).to eq(['Destination A', 'Destination B', 'Destination C'])
    end
  end

  describe '.days_all' do
    before do
      create(:tour, days: 10)
      create(:tour, days: 5)
      create(:tour, days: 10)
    end

    it 'returns a list of unique days ordered by days' do
      result = described_class.days_all
      expect(result).to eq([5, 10])
    end
  end

  describe '.start_dates_all' do
    before do
      create(:tour, start_date: Date.new(2025, 10, 25))
      create(:tour, start_date: Date.new(2025, 11, 1))
      create(:tour, start_date: Date.new(2025, 10, 25))
    end

    it 'returns a list of unique start dates ordered by start_date formatted as MM/DD/YYYY' do
      result = described_class.start_dates_all
      expect(result).to eq([['10/25/2025', Date.new(2025, 10, 25)], ['11/01/2025', Date.new(2025, 11, 1)]])
    end
  end
end
