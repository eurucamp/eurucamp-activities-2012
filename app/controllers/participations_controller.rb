class ParticipationsController < ApplicationController
  respond_to :html

  def index
    @activities = Repository.all
    respond_with @activities
  end
end
