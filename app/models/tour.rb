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

  AVAILABILITY = {
    available: 'Available',
    limited: 'Limited',
    sold_out: 'Sold Out'
  }.freeze

  scope :available, -> { where('seats_available > ?', 5) }
  scope :limited, -> { where('seats_available > ? AND seats_available <= ?', 0, 5) }
  scope :sold_out, -> { where('seats_available <= ?', 0) }

  def availability
    case seats_available
    when 6..Float::INFINITY
      AVAILABILITY[:available]
    when 1..5
      AVAILABILITY[:limited]
    when -Float::INFINITY..0
      AVAILABILITY[:sold_out]
    end
  end

  def self.search(params)
    @tours = Tour.all

    @tours = @tours.where(days: params[:days]) if params[:days].present?
    @tours = @tours.where(name: params[:name]) if params[:name].present?
    @tours = @tours.where(start_date: params[:start_date]) if params[:start_date].present?

    @tours = @tours.available if search_available?(params)
    @tours = @tours.limited if search_limited?(params)
    @tours = @tours.sold_out if search_sold_out?(params)

    @tours
  end

  def self.search_available?(params)
    params[:availability].present? && params[:availability] == AVAILABILITY[:available]
  end

  def self.search_limited?(params)
    params[:availability].present? && params[:availability] == AVAILABILITY[:limited]
  end

  def self.search_sold_out?(params)
    params[:availability].present? && params[:availability] == AVAILABILITY[:sold_out]
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
