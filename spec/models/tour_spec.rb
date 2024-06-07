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

      it 'returns "Available"' do
        tour.seats_available = seats_available
        expect(tour.availability).to eq('Available')
      end
    end

    context 'when seats_available is between 1 and 5' do
      let(:seats_available) { 3 }

      it 'returns "Limited"' do
        tour.seats_available = seats_available
        expect(tour.availability).to eq('Limited')
      end
    end

    context 'when seats_available is 0' do
      let(:seats_available) { 0 }

      it 'returns "Sold Out"' do
        tour.seats_available = seats_available
        expect(tour.availability).to eq('Sold Out')
      end
    end
  end
end
