require File.expand_path('../config/environment', __dir__)
require File.expand_path('../config/dt_env.rb', File.dirname(__FILE__))
require 'rspec/rails'
require 'capybara'
require 'capybara/rspec'
require 'qt_plugin_messages_suppressed'
require 'download_helper'
require 'capybara-screenshot/rspec'
require 'rspec/retry'
require 'nokogiri'
require 'open-uri'
require 'webdrivers'
require 'pry'
require 'pry-nav'

# webdrivers debug
# Webdrivers.logger.level = :DEBUG

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }
Capybara.javascript_driver = :selenium
Capybara.default_driver = :selenium_chrome_headless
# Capybara.default_driver = :firefox_headless
Capybara.ignore_hidden_elements = true
Capybara.default_max_wait_time = 15

# firefox
Capybara.register_driver :firefox_headless do |app|
  options = ::Selenium::WebDriver::Firefox::Options.new
  options.args << '--headless'

  Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
end

# chrome
Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Chrome::Profile.new
  profile['download.default_directory'] = DownloadHelper::PATH.to_s
  profile['download.prompt_for_download'] = false
  profile['browser.download.folderList'] = 2
  profile['browser.helperApps.neverAsk.saveToDisk'] = 'text/csv, text/html, application/vnd.ms-excel, application/msword'

  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--window-size=1920,1080')

  Capybara::Selenium::Driver.new(app, browser: :chrome, profile: profile, options: options)
end

# headless chrome
Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  options.add_argument('--no-sandbox')
  # options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--disable-popup-blocking')
  options.add_argument('--window-size=1920,1080')
  options.add_argument('--enable-features=NetworkService,NetworkServiceInProcess')
  options.add_argument('--ignore-ssl-errors=yes')
  options.add_argument('--ignore-certificate-errors')

  options.add_preference(:download, directory_upgrade: true, prompt_for_download: false, default_directory: DownloadHelper::PATH.to_s)
  options.add_preference(:browser, set_download_behavior: { behavior: 'allow' })

  driver = Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)

  bridge = driver.browser.send(:bridge)

  path = '/session/:session_id/chromium/send_command'
  path[':session_id'] = bridge.session_id

  bridge.http.call(:post, path, cmd: 'Page.setDownloadBehavior', params: { behavior: 'allow', downloadPath: DownloadHelper::PATH.to_s })

  driver
end

RSpec.configure do |config|
  config.include ERB::Util
  config.include Capybara::DSL
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.expose_current_running_example_as :example
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.filter_run_excluding :ignore
  config.profile_examples = false

  # rspec-retry
  # show retry status in spec process
  config.verbose_retry = true
  config.display_try_failure_messages = true

  # seconds to wait between retries
  config.default_sleep_interval = 1
  config.default_retry_count = 1
end

# screenshot support for headless chrome driver
Capybara::Screenshot.register_driver(:selenium_chrome_headless) do |driver, path|
  driver.browser.save_screenshot(path)
end

# screenshot support for selenium driver
Capybara::Screenshot.register_driver(:selenium) do |driver, path|
  driver.browser.save_screenshot path
end

Capybara::Screenshot.register_driver(:firefox_headless) do |driver, path|
  driver.browser.save_screenshot(path)
end

