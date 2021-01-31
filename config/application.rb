require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you"ve limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleApp2
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :vi
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # config.assets.version = "1.0"

    config.before_configuration do
      env_file = File.join(Rails.root, "config", "application.yml")
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
    end if File.exists?(env_file)
end
  end
end
