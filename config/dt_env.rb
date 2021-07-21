require File.expand_path("./dt_env/#{ENV['DT_ENV']}.rb", File.dirname(__FILE__))
require File.expand_path('./dt_env_common_settings.rb', File.dirname(__FILE__))

Capybara.configure do |config|
  config.app_host   = $SECURE_BASE_URL
  config.run_server = false
end
