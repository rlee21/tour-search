# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_cable/engine'

Bundler.require(*Rails.groups)

module TourSearch
  class Application < Rails::Application
    config.load_defaults 7.1
    config.autoload_lib(ignore: %w[assets tasks])
    config.generators.system_tests = nil
    # Prefer sql format over ruby format because it allows you
    # to see actual sql that will be run when migration is run
    config.active_record.schema_format = :sql
  end
end
