#thx Sferik

def a_delete(path, endpoint='https://api.twitter.com')
  a_request(:delete, endpoint + path)
end

def a_get(path, endpoint='https://api.twitter.com')
  a_request(:get, endpoint + path)
end

def a_post(path, endpoint='https://api.twitter.com')
  a_request(:post, endpoint + path)
end

def a_put(path, endpoint='https://api.twitter.com')
  a_request(:put, endpoint + path)
end

def stub_delete(path, endpoint='https://api.twitter.com')
  stub_request(:delete, endpoint + path)
end

def stub_get(path, endpoint='https://api.twitter.com')
  stub_request(:get, endpoint + path)
end

def stub_post(path, endpoint='https://api.twitter.com')
  stub_request(:post, endpoint + path)
end

def stub_put(path, endpoint='https://api.twitter.com')
  stub_request(:put, endpoint + path)
end

def fake_tweet(
      text       = "@#{Settings.twitter.account} hi!",
      entities   = {
        :user_mentions => [{:screen_name => Settings.twitter.account, :name => Settings.twitter.account, :id => 112233, :id_str => "112233", :indices => [0, Settings.twitter.account.size - 1]}],
        :urls          => [],
        :hashtags      => []
      },
      created_at = Time.zone.now,
      from       = {:user => "yomakov",                :id => 667788},
      to         = {:user => Settings.twitter.account, :id => 112233}
    )

  tweet_id = rand(100_000_000)

  tweet_attributes = {
    :from_user => from[:user],
    :from_user_id => from[:id],
    :from_user_id_str => from[:id].to_s,
    :from_user_name => from[:user_name] || from[:user],
    :geo => nil,
    :id => tweet_id,
    :id_str => tweet_id.to_s,
    :iso_language_code => "en",
    :metadata => {:result_type => "recent"},
    :profile_image_url => "http://a0.twimg.com/profile_images/2301782054/f7z3cvb34hfagf0g3io3_normal.jpeg",
    :profile_image_url_https => "https://si0.twimg.com/profile_images/2301782054/f7z3cvb34hfagf0g3io3_normal.jpeg",
    :source => "&lt;a href=&quot;http://twitter.com/&quot;&gt;web&lt;/a&gt;",
    :to_user => to[:user],
    :to_user_id => to[:id],
    :to_user_id_str => to[:id].to_s,
    :to_user_name => to[:user_name] || to[:user],
    :in_reply_to_status_id => nil,
    :in_reply_to_status_id_str => nil,

    :created_at => created_at.to_s,
    :entities => entities,
    :text => text
  }

  Twitter::Status.new(tweet_attributes)
end

def activity_tweet(
    text       = "@#{Settings.twitter.account} ##{Settings.twitter.tokens.im_out} #DRN",
    entities   = {
      :user_mentions => [{:screen_name => Settings.twitter.account, :name => Settings.twitter.account, :id => 112233, :id_str => "112233", :indices => [0, Settings.twitter.account.size - 1]}],
      :urls          => [],
      :hashtags      => [{:text => "#{Settings.twitter.tokens.im_out}"}, {:text => "DRN"} ]
    },
    created_at = Time.zone.now,
    from       = {:user => "yomakov",                :id => 667788},
    to         = {:user => Settings.twitter.account, :id => 112233}
  )

  fake_tweet(text, entities, created_at, from, to)
end

def im_out(code = "DRN", created_at = Time.zone.now)
  activity_tweet(
    "@#{Settings.twitter.account} ##{Settings.twitter.tokens.im_out} ##{code}",
    {
      :user_mentions => [{:screen_name => Settings.twitter.account, :name => Settings.twitter.account, :id => 112233, :id_str => "112233", :indices => [0, Settings.twitter.account.size - 1]}],
      :urls          => [],
      :hashtags      => [{:text => "#{Settings.twitter.tokens.im_out}"}, {:text => code} ]
    },
    created_at
  )
end

def im_in(code = "DRN", created_at = Time.zone.now)
  activity_tweet(
      "@#{Settings.twitter.account} ##{Settings.twitter.tokens.im_in} ##{code}",
      {
          :user_mentions => [{:screen_name => Settings.twitter.account, :name => Settings.twitter.account, :id => 112233, :id_str => "112233", :indices => [0, Settings.twitter.account.size - 1]}],
          :urls          => [],
          :hashtags      => [{:text => "#{Settings.twitter.tokens.im_in}"}, {:text => code} ]
      },
      created_at
  )
end
