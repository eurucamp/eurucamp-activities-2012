class NotificationsController < ApplicationController

  def create
    Rails.logger.warn params.inspect
  end
end
