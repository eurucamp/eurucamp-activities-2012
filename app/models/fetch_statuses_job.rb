class FetchStatusesJob
  def perform
    run!
  end

  def run!
    query = "to:#{Settings.twitter.account} '#{Settings.twitter.tokens.im_in} OR #{Settings.twitter.tokens.im_out}'"

    SortedSet.new(Twitter.search(query, :rpp => 100, :result_type => "recent").results).map do |status|
      activity = Activity.where(:code => status.code).first
      if activity
        args = {:code => status.code, :account => status.from_user}
        if status.in? && !activity.participations.where(args).exists?
          activity.participations.create(args)
          Twitter.update("@#{status.from_user} #{Settings.twitter.messages.in} #{status.code}") rescue nil
        elsif status.out?
          participation = activity.participations.where(args).first
          if participation && status.created_at > participation.created_at
            activity.participations.delete_all(args)
            Twitter.update("@#{status.from_user} #{Settings.twitter.messages.out} #{status.code}") rescue nil
          end
        end
      end
    end
  end
end
