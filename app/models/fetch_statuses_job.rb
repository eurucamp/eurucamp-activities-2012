class FetchStatusesJob
  def perform
    run!
  end

  def run!
    query = "to:#{Settings.twitter.account} '#{Settings.twitter.tokens.im_in} OR #{Settings.twitter.tokens.im_out}'"

    results = Twitter.search(query, :rpp => 100, :result_type => "recent", :include_entities => true).
                      results.
                      sort { |x,y| y.attrs[:created_at] <=> x.attrs[:created_at] } # newer first

    SortedSet.new(results).map do |status|
      activity = Activity.where(:code => status.code).first
      if activity
        args = {:account => status.from_user}
        if status.in? && !activity.participations.where(args).exists?
          activity.participations.create(args)
        elsif status.out?
          activity.participations.delete_all(args)
        end
      end
    end
  end
end
