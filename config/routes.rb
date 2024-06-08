# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tours#index'
  resources :tours, only: :index
end
