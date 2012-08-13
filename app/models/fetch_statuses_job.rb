class FetchStatusesJob
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