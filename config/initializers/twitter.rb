Twitter::Status.class_eval do
  def in?
    @_in ||= hashtags_downcased.include?(Settings.twitter.tokens.im_in.downcase)
  end

  def out?
    @_out ||= hashtags_downcased.include?(Settings.twitter.tokens.im_out.downcase)
  end

  def valid?
    !code.blank? && ((in? && !out?) || (!in? && out?))
  end

  def code
    codes.first
  end

  def codes
    @codes ||= hashtags_downcased - [Settings.twitter.tokens.im_in.downcase, Settings.twitter.tokens.im_out.downcase]
  end

  alias :old_comparator :<=>
  def <=>(other)
    # TODO: refactor me
    if self == other ||
       (codes == other.codes && from_user == other.from_user && to_user == other.to_user && in? == other.in? && out? == other.out?)
      0
    elsif created_at && other.created_at
      created_at <=> other.created_at
    else
      old_comparator(other)
    end
  end

  private

    def hashtags_downcased
      @hashtags_downcased ||= hashtags.map { |h| h.text.downcase  }
    end
end