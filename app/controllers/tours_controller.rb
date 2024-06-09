# frozen_string_literal: true

class ToursController < ApplicationController
  def index
    tours = Tour.search(tour_params)
    @pagy, @tours = pagy(tours.all, items: 10)
  end

  private

  def tour_params
    params.permit(:name, :days, :start_date, :availability, :page)
  end
end
