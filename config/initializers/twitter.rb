Twitter::Status.class_eval do
  def in?
    @_in ||= !(text !~ /@#{Settings.twitter.account}\s*[,:]?\s*#{Settings.twitter.tokens.im_in}\s*/)
  end

  def out?
    @_out ||= !(text !~ /@#{Settings.twitter.account}\s*[,:]?\s*#{Settings.twitter.tokens.im_out}\s*/)
  end

  def code
    text.gsub(/@#{Settings.twitter.account}\s*[,:]?\s*#{Settings.twitter.tokens.send(in? ? :im_in : :im_out)}\s*/,"").strip if in? || out?
  end
end