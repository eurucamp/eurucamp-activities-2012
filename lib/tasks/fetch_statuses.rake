namespace :utils do
  task :fetch_statuses, [:needs] => [:environment] do |t,args|
    FetchStatusesJob.new.run!
  end
end
