# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

gem 'bootsnap', require: false                  # Reduces boot times through caching; required in config/boot.rb
gem 'importmap-rails', '~> 2.0'                 # Use JavaScript with ESM import maps
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.4'
gem 'rails', '~> 7.1.3'
gem 'sprockets-rails', '~> 3.4'                 # Original asset pipeline
gem 'stimulus-rails', '~> 1.3'                  # Hotwire's modest JavaScript framework
gem 'tailwindcss-rails', '~> 2.4'
gem 'turbo-rails', '~> 2.0'                     # Hotwire's SPA-like page accelerator
gem 'tzinfo-data', platforms: %i[windows jruby] # Windows does not include zoneinfo files

group :development, :test do
  gem 'debug', platforms: %i[mri windows]
  gem 'dotenv-rails', '~> 3.1'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'faker', '~> 3.3'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'rspec-rails', '~> 6.1'
  gem 'rubocop-rails', '~> 2.23', require: false
  gem 'rubocop-rspec', '~> 2.26', require: false
end

group :development do
  gem 'annotate', '~> 3.1'                      # Documents ActiveRecord models with database columns
  gem 'web-console', '~> 4.2'
end

group :test do
  gem 'shoulda-matchers', '~> 6.2'
end
