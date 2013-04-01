source "https://rubygems.org"

ruby "1.9.3"

gem "rails", "3.2.11"
gem "twitter",       "~> 4.0.0"
gem "haml",          "~> 3.1.6"
gem "settingslogic", "~> 2.0.8"
gem "mongoid",       "~> 3.0.0"
gem "delayed_job_mongoid", "~> 2.0.0"
gem "clockwork",     "~> 0.4.1"
gem "oj",            "~> 1.3.4"
gem "heroku_san",    "~> 3.0.2"
gem "rails_admin"
gem "devise",        "~> 2.1.2"
gem "frontend-helpers"
gem "newrelic_rpm"

group :assets do
  gem "sass",         "~> 3.2.0"
  gem "sass-rails",   "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"
  gem "bourbon"

  gem "uglifier", ">= 1.0.3"
end

gem "jquery-rails"

group :development do
  gem "heroku",      :require => false
end

group :test do
  gem "webmock"
end

group :development, :test do
  gem "rspec-rails"
  gem "timecop"
  gem "mongoid-rspec"
  gem "database_cleaner", "~> 0.8.0"
  gem "rack-test",        "~> 0.6.1"
end

group :production do
  gem "puma"
end
