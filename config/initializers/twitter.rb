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