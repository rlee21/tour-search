# frozen_string_literal: true

class CreateTours < ActiveRecord::Migration[7.1]
  def change
    create_table :tours do |t|
      t.string :external_id, null: false, index: { unique: true, name: 'unique_external_ids' }
      t.string :name, null: false, index: true
      t.integer :days, null: false, index: true
      t.date :start_date, null: false, index: true
      t.date :end_date, null: false
      t.string :start_city, null: false
      t.string :end_city, null: false
      t.integer :seats_available
      t.integer :seats_booked
      t.integer :seats_maximum
      t.integer :status

      t.timestamps
    end
  end
end
