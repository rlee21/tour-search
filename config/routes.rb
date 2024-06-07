# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tours#index'
  resources :tours, only: :index do
    collection do
      # post 'search', defaults: { format: 'turbo_stream' }
      post 'search'
    end
  end
end
