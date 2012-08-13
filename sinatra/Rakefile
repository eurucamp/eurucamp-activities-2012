require "bundler/setup"
require "bundler/setup"
require "heroku_san"

config_file = File.join(File.expand_path(File.dirname(__FILE__)), 'config', 'heroku.yml')
HerokuSan.project = HerokuSan::Project.new(config_file, :deploy => HerokuSan::Deploy::Sinatra)
load "heroku_san/tasks.rb"

require "./app"

desc "Fetch statuses"
task :fetch_statuses do
  Eurucamp::Activities::Job.new.run!
end

desc "Create indexes"
task :create_indexes do
  Eurucamp::Activities::Participation.create_indexes
end