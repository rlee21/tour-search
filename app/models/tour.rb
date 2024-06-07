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
class Tour < ApplicationRecord
  validates :external_id, :name, :days, :start_date, :end_date, :start_city, :end_city, presence: true

  validates :days, numericality: { only_integer: true, greater_than: 0 }
  validates :seats_available, numericality: { only_integer: true }
  validates :seats_booked, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :seats_maximum, numericality: { only_integer: true, greater_than: 0 }

  validate :end_date_after_start_date
  validate :seats_available_not_exceed_maximum

  enum :status, { Active: 0, Inactive: 1 }, prefix: true

  def availability
    case seats_available
    when 6..Float::INFINITY
      'Available'
    when 1..5
      'Limited'
    when 0
      'Sold Out'
    end
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    return unless end_date < start_date

    errors.add(:end_date, 'must be equal to or after the start date')
  end

  def seats_available_not_exceed_maximum
    return unless seats_available > seats_maximum

    errors.add(:seats_available, 'cannot exceed the maximum number of seats')
  end
end
