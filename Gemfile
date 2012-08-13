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


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass",         "~> 3.2.0"
  gem "sass-rails",   "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem "therubyracer", :platforms => :ruby

  gem "uglifier", ">= 1.0.3"
end

gem "jquery-rails"

group :development do
  gem "heroku",      :require => false
end

group :development, :test do
  gem "rspec",       "~> 2.10.0"
  gem "rack-test",   "~> 0.6.1"
end

group :production do
  gem "thin"
end
