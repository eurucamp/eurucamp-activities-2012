require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

every(1.minutes, 'Queueing interval job') { Delayed::Job.enqueue IntervalJob.new }
