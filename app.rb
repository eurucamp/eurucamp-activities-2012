require "twitter"
require "settingslogic"
require "sinatra"
require "haml"
require "mongoid"

class Settings < Settingslogic
  source "./config/application.yml"
  namespace settings.environment.to_s
end

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
end

module Eurucamp
  module Activities

    class Repository
      def self.activities
        Settings.activities.sort { |x,y| x["when"] <=> y["when"] }
      end

      def self.codes
        activities.map { |a| a["code"] }
      end

      def self.all
        Settings.activities.map do |activity|
          activity.merge("participations" => Participation.where(:code => activity["code"]))
        end
      end
    end

    class Participation
      include Mongoid::Document
      include Mongoid::Timestamps
      include ActiveModel::Validations

      field :code
      field :account

      index({ :code => 1, :account => 1 }, { :unique => true, :drop_dups => true })
      validates :code, :inclusion => { :in => Repository.codes, :allow_blank => false }
    end

    class Job
      def run!
        query = "to:#{Settings.twitter.account} '#{Settings.twitter.tokens.im_in} OR #{Settings.twitter.tokens.im_out}'"
        Twitter.search(query, :rpp => 100, :result_type => "recent").results.sort{ |x, y| x.created_at <=> y.created_at }.map do |status|
          args = {:code => status.code, :account => status.from_user}
          if status.in?
            Participation.create(args)
          elsif status.out?
            Participation.delete_all(args)
          end
        end
      end
    end

    class WebApp < Sinatra::Base
      configure do
        Mongoid.logger.level = Logger::DEBUG
        Moped.logger.level = Logger::DEBUG
        enable :logging

        Mongoid.load!("./config/mongoid.yml")
        Participation.create_indexes # TODO this should be in Rake task
      end

      get "/" do
        Job.new.run! # TODO temporary, it should be moved to backogrund worker
        haml :index, :locals => { :activities =>  Repository.all}
      end
    end

  end
end

