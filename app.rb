require "twitter"
require "settingslogic"
require "sinatra"
require "haml"
require "mongoid"

Twitter::Status.class_eval do
  def in?
    @_in ||= !(text !~ /@#{Settings.twitter.account}\W+#{Settings.twitter.tokens.im_in}\W*/)
  end

  def out?
    @_out ||= !(text !~ /@#{Settings.twitter.account}\W+#{Settings.twitter.tokens.im_out}\W*/)
  end

  def code
    text.gsub(/@#{Settings.twitter.account}\W+#{Settings.twitter.tokens.send(in? ? :im_in : :im_out)}\W*/,"") if in? || out?
  end

  def attendee
    from_user
  end
end

module Eurucamp
  module Activities

    class Participant
      include Mongoid::Document
      include Mongoid::Timestamps

      field :code
      field :account

      index({ code: 1, account: 1 }, { unique: true })
    end

    class Job
      def run
      end
    end

    class Repository
      def self.all
        Settings.activities
      end
    end

    class Settings < Settingslogic
      source "./config/application.yml"
      namespace settings.environment.to_s
    end

    class WebApp < Sinatra::Base
      configure do
        Mongoid.logger.level = Logger::DEBUG
        Moped.logger.level = Logger::DEBUG
        enable :logging

        Mongoid.load!("./config/mongoid.yml")
      end

      get "/" do
        haml :index, :locals => { :activities =>  Repository.all}
      end
    end

  end
end
