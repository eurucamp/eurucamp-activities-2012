Twitter::Status.class_eval do
  def in?
    @_in ||= !(text.downcase !~ /@#{Settings.twitter.account.downcase}\s*[,:]?\s*#{Settings.twitter.tokens.im_in.downcase}\s*/)
  end

  def out?
    @_out ||= !(text.downcase !~ /@#{Settings.twitter.account.downcase}\s*[,:]?\s*#{Settings.twitter.tokens.im_out.downcase}\s*/)
  end

  def code
    text.downcase.gsub(/@#{Settings.twitter.account.downcase}\s*[,:]?\s*#{Settings.twitter.tokens.send(in? ? :im_in : :im_out).downcase}\s*/,"").strip if in? || out?
  end

  alias :old_comparator :<=>
  def <=>(other)
    # TODO: refactor me
    if self == other ||
       (code == other.code && from_user == other.from_user && to_user && other.to_user && ((in? && other.in?) || (out? && other.out?)))
      0
    elsif created_at && other.created_at
      created_at <=> other.created_at
    else
      old_comparator(other)
    end
  end
end