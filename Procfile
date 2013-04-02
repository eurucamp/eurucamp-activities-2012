web: bundle exec puma -e $RACK_ENV -t 1:4 -b tcp://0.0.0.0:$PORT
clock: bundle exec clockwork lib/clock.rb
worker:  bundle exec rake jobs:work