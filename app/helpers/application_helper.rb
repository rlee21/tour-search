# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def format_date(date)
    return '' if date.blank?

    return '' unless date.is_a?(Date)

    date.strftime('%m/%d/%Y')
  end
end
