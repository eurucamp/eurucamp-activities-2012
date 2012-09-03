  class FetchStatusesJob
  def perform
    run!
  end

  def run!
    query = "to:#{Settings.twitter.account} '#{Settings.twitter.tokens.im_in} OR #{Settings.twitter.tokens.im_out}'"

    SortedSet.new(Twitter.search(query, :rpp => 100, :result_type => "recent", :include_entities => true).results).map do |status|
      activity = Activity.where(:code => status.code).first
      if activity
        args = {:code => status.code, :account => status.from_user}
        if status.in? && !activity.participations.where(args).exists?
          activity.participations.create(args)
        elsif status.out?
          participation = activity.participations.where(args).first
          if participation
            activity.participations.delete_all(args)
          end
        end
      end
    end
  end
end
