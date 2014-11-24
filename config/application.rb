require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module InfraOps
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.middleware.use ActionDispatch::Flash
    config.api_only = false

    # Auto load files after rails initialization
    config.after_initialize do
      dirs = [File.join(config.root, "lib", "core_ext", "**", "*.rb")]
      Dir[*dirs].each {|file| require file }
    end

    config.to_prepare do
      # Base layout. Uses app/views/layouts/my_layout.html.erb
      Doorkeeper::ApplicationController.layout "sign_in"

      # Only Applications list
      Doorkeeper::ApplicationsController.layout "admin"

      # Only Authorization endpoint
      Doorkeeper::AuthorizationsController.layout "sign_in"

      # Only Authorized Applications
      Doorkeeper::AuthorizedApplicationsController.layout "sign_in"
    end

  end
end
