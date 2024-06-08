# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ToursController do
  describe '#index' do
    it 'returns a successful response' do
      get tours_path

      expect(response).to be_successful
      expect(response).to render_template(:index)
      expect(response.body).to include('Find a Tour')
    end
  end
end
