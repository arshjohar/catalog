require 'cucumber/rails'

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Cucumber::Rails::Database.javascript_strategy = :truncation

if ENV['headless'] =~ /false/i
  Capybara.default_driver = Capybara.javascript_driver = :selenium
else
  Capybara.default_driver = Capybara.javascript_driver = :webkit
end

WebMock.allow_net_connect!

