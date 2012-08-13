class FetchStatusesJob
  def run!
    query = "to:#{Settings.twitter.account} '#{Settings.twitter.tokens.im_in} OR #{Settings.twitter.tokens.im_out}'"
    Twitter.search(query, :rpp => 100, :result_type => "recent").results.sort{ |x, y| x.created_at <=> y.created_at }.map do |status|
      activity = Activity.where(:code => status.code).first
      if activity
        args = {:code => status.code, :account => status.from_user}
        if status.in?
          activity.participations.create(args)
        elsif status.out?
          activity.participations.delete_all(args)
        end
      end
    end
  end
end