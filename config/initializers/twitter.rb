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