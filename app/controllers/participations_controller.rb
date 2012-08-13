class ParticipationsController < ApplicationController
  respond_to :html

  def index
    Rails.logger.info "@@@@@@#{Rails.env} ENV: #{ENV.inspect}"
    FetchStatusesJob.new.run! if Rails.env.development?
    @activities = Repository.all
    respond_with @activities
  end
end
