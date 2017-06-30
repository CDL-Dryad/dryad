require 'rails_helper'
require 'capybara/dsl'
require 'capybara/rails'
require 'capybara/rspec'

# ------------------------------------------------------------
# Capybara

Capybara.register_driver(:selenium) do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, args: ['--incognito'])
end

Capybara.javascript_driver = :chrome

Capybara.configure do |config|
  config.default_max_wait_time = 10
  config.default_driver = :selenium
  config.server_port = 33_000
  config.app_host = 'http://localhost:33000'
end

# ------------------------------------------------------------
# Solr

require 'solr_helper'

SolrHelper.start

# ------------------------------------------------------------
# RSpec

RSpec.configure do |config|
  # Treat specs in features/ as feature specs
  config.infer_spec_type_from_file_location!

  # Mock OmniAuth login
  config.before(:suite) do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(
      :google_oauth2,
      uid: '555555555555555555555',
      credentials: {
        token: 'ya29.Ry4gVGVzdHkgTWNUZXN0ZmFjZQ'
      },
      info: {
        email: 'test@example.edu.test-google-a.com',
        name: 'G. Testy McTestface',
        test_domain: 'localhost'
      }
    )
  end

  # Stop Solr when we're done
  config.after(:suite) { SolrHelper.stop }
end

# ------------------------------------------------------------
# Misc. helper methods

def home_page_title
  @home_page_title ||= begin
    home_html_erb = File.read("#{STASH_ENGINE_PATH}/app/views/stash_engine/pages/home.html.erb")
    home_html_erb[/page_title = '([^']+)'/, 1]
  end
end
