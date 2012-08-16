source "https://rubygems.org"

ruby "1.9.3"
gem "rails", "3.2.8"
gem "twitter",       "~> 3.5.0"
gem "haml",          "~> 3.1.6"
gem "settingslogic", "~> 2.0.8"
gem "mongoid",       "~> 3.0.0"
gem "oj",            "~> 1.3.4"
gem "heroku_san",    "~> 3.0.2"
gem "rails_admin"
gem "devise",        "~> 2.1.2"
gem "frontend-helpers"

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

group :development, :test do
  gem "rspec-rails"
  gem "webmock"
  gem "timecop"
  gem "mongoid-rspec"
  gem "database_cleaner"
  gem "rack-test",   "~> 0.6.1"
end

group :production do
  gem "puma"
end
