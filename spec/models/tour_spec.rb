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
    let(:tour_available) { create(:tour, seats_available: 10) }
    let(:tour_limited) { create(:tour, seats_available: 3) }
    let(:tour_sold_out) { create(:tour, seats_available: 0) }

    context 'when available scope' do
      it 'returns available tours' do
        expect(described_class.available).to include(tour_available)
        expect(described_class.available).not_to include(tour_limited, tour_sold_out)
      end
    end

    context 'when limited scope' do
      it 'returns limited tours' do
        expect(described_class.limited).to include(tour_limited)
        expect(described_class.limited).not_to include(tour_available, tour_sold_out)
      end
    end

    context 'when sold_out scope' do
      it 'returns sold out tours' do
        expect(described_class.sold_out).to include(tour_sold_out)
        expect(described_class.sold_out).not_to include(tour_available, tour_limited)
      end
    end
  end

  describe '.search' do
    let(:tour_a) { create(:tour, name: 'Tour A', days: 10, start_date: '2025-10-25', seats_available: 10) }
    let(:tour_b) { create(:tour, name: 'Tour B', days: 5, start_date: '2025-11-01', seats_available: 3) }
    let(:tour_c) { create(:tour, name: 'Tour C', days: 7, start_date: '2025-10-30', seats_available: 0) }

    context 'when searching by name' do
      it 'returns tours matching the name' do
        result = described_class.search(name: 'Tour A')
        expect(result).to contain_exactly(tour_a)
      end
    end

    context 'when searching by days' do
      it 'returns tours matching the number of days' do
        result = described_class.search(days: 5)
        expect(result).to contain_exactly(tour_b)
      end
    end

    context 'when searching by start_date' do
      it 'returns tours matching the start date' do
        result = described_class.search(start_date: '2025-10-25')
        expect(result).to contain_exactly(tour_a)
      end
    end

    context 'when searching by availability' do
      it 'returns tours that are available' do
        result = described_class.search(availability: Tour::AVAILABILITY[:available])
        expect(result).to contain_exactly(tour_a)
      end

      it 'returns tours that are limited' do
        result = described_class.search(availability: Tour::AVAILABILITY[:limited])
        expect(result).to contain_exactly(tour_b)
      end

      it 'returns tours that are sold out' do
        result = described_class.search(availability: Tour::AVAILABILITY[:sold_out])
        expect(result).to contain_exactly(tour_c)
      end
    end

    context 'when searching by multiple parameters' do
      it 'returns tours matching all criteria' do
        result = described_class.search(name: 'Tour A', days: 10, start_date: '2025-10-25')
        expect(result).to contain_exactly(tour_a)
      end
    end

    context 'when no parameters are provided' do
      it 'returns all tours' do
        result = described_class.search({})
        expect(result).to contain_exactly(tour_a, tour_b, tour_c)
      end
    end
  end
end
