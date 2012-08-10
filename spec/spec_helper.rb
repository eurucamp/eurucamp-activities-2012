ENV["RACK_ENV"] = "test"

require File.expand_path("../../app", __FILE__)
require 'rspec'
require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include Module.new { def app ; Eurucamp::Activities::WebApp ; end }
end