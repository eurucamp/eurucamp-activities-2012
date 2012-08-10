require "twitter"
require "settingslogic"
require "sinatra"
require "haml"
require "mongoid"

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
        #Twitter.search("to:#{Settings.twitter.account} '#{Settings.twitter.tokens.im_in}'", :result_type => "recent").results.map do |status|
        #  most_likely_a_code = status.text.gsub(/@#{Settings.twitter.account}\W+#{Settings.twitter.tokens.im_in}\W*/,"")
        #  p most_likely_a_code
        #end
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
