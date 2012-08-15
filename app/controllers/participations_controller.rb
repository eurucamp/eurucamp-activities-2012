class ParticipationsController < ApplicationController
  respond_to :html

  def index
    # FetchStatusesJob.new.run! if Rails.env.development?
    @activities = Activity.published
    respond_with @activities
  end
end
