# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#format_date' do
    context 'when date is present' do
      it 'formats the date as MM/DD/YYYY' do
        date = Date.new(2025, 10, 25)
        expect(helper.format_date(date)).to eq('10/25/2025')
      end
    end

    context 'when date is blank' do
      it 'returns an empty string' do
        expect(helper.format_date(nil)).to eq('')
        expect(helper.format_date('')).to eq('')
      end
    end

    context 'when date is a string' do
      it 'returns an empty string' do
        expect(helper.format_date('2025-10-25')).to eq('')
      end
    end
  end
end
