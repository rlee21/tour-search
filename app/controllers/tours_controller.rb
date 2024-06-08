# frozen_string_literal: true

class ToursController < ApplicationController
  def index
    @tours = Tour.search(tour_params)
  end

  private

  def tour_params
    params.permit(:name, :days, :start_date, :availability)
  end
end
