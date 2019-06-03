# frozen_string_literal: true

require 'twitter'

module GetTweet::Tweet
  module_function

  def count
    # count Twitter
    count_tweet


  end

  def count_tweet
    tc = Parameter.find_or_create_by(key: 'twitter_count')
    tc.value_int = TweetText.all.count
    tc.save
  end

  def batch
    Rails.application.eager_load!
    begin
      streaming.sample do |t|
        delay.store_tweet(t, true) if t.is_a?(Twitter::Tweet) && (t.lang == 'ja' || t.lang == 'en')
        delay.check_tweet(t) if t.is_a?(Twitter::Streaming::DeletedTweet)
      end
    rescue EOFError
      p 'EOF error, reconnect'
      sleep(1.minutes)
      retry
    rescue ActiveRecord::StatementInvalid => e
      p 'postgres error, reconnect'
      p e
      ActiveRecord::Base.connection.reconnect!
      retry
    rescue JSON::ParserError
      p 'Exceeded connection limit for user'
      sleep(1.minutes)
      retry
    rescue ActiveRecord::ConnectionTimeoutError
      p 'Oracle connection time out'
      retry
    rescue Errno::ECONNRESET
      p 'connection reset'
      retry
    rescue HTTP::ConnectionError
      p 'HTTP error, reconnect'
      sleep(1.minute)
      ActiveRecord::Base.connection.reconnect!
      retry
    end
  end


  def reply
    loop do
      Rails.application.eager_load!
      tweets = TweetText.where(reply_check: true).limit(100)
      if tweets.count.positive?
        tweets.each do |t|
          store_tweet_with_parent(t.in_reply_to_status_id) if t.reply?
          store_tweet_with_parent(t.retweet_id) if t.retweet?
          t.reply_check = false
          t.save
        rescue Twitter::Error::TooManyRequests => error
          weight_time = error.rate_limit.reset_in + 1
          p 'too many requests, sleep ' + weight_time.to_s
          sleep(weight_time.seconds)
        rescue ActiveRecord::RecordNotFound => error
          p error
          p 'ActiveRecord, RecordNotFound'
        end
      else
        Rails.logger.info('no tweet to get, sleep 5 minutes')
        sleep(5.minutes)
      end
    rescue ActiveRecord::StatementInvalid
      p 'database error, reconnect'
      ActiveRecord::Base.connection.reconnect!
    rescue HTTP::ConnectionError
      p 'HTTP error, reconnect'
      sleep(1.minute)
      ActiveRecord::Base.connection.reconnect!
    end
  end

  def ranking
    loop do
      ActiveRecord::Base.transaction do
        now = DateTime.now
        hashtags = []
        urls = []
        TweetText.where(created_at: now - 1.hour..now).includes(:tweets_hash_tags, :hash_tags, :tweets_urls, :urls).each do |t|
          t.hash_tags.each do |h|
            hashtags << h
          end
          t.urls.each do |u|
            urls << u
          end
        end

        hashtags.group_by(&:itself).map {|k, v| [k, v.size]}.sort_by {|k, v| -v}.to_h.each do |k, v|
          RecentHashTag.create(hash_tag: k, count: v, created_at: now)
        end
        urls.group_by(&:itself).map {|k, v| [k, v.size]}.sort_by {|k, v| -v}.to_h.each do |k, v|
          RecentUrl.create(url: k, count: v, created_at: now)
        end
      end
      sleep(20.minutes)
    rescue ActiveRecord::StatementInvalid
      p 'postgres error, reconnect'
      ActiveRecord::Base.connection.reconnect!
    end
  end

  def media
    loop do
      subdir = Date.today.strftime('%Y%m%d')
      Medium.where(downloaded: false).limit(100).each do |m|
        p m.url
        m.subdir = subdir
        download_image(m.url, subdir)
        m.downloaded = true
        m.save
        random = Random.new
        sleep(random.rand(2.0) * 0.1 + 0.4)
      end
    rescue Errno::ENETUNREACH
      sleep(1.hour)
    rescue Net::OpenTimeout
      sleep(10.minutes)
    rescue ActiveRecord::StatementInvalid
      p 'postgres error, reconnect'
      sleep(1.minutes)
    rescue HTTP::ConnectionError
      p 'HTTP error, reconnect'
      sleep(1.minute)
    end
  end

  def check_tweet(tweet)
    tweet = TweetText.find(tweet.id)
    tweet.deleted = true
    tweet.save
  rescue ActiveRecord::RecordNotFound
    #p 'record not found'
  end

  def store_tweet_with_parent(tweet_id)
    begin
      TweetText.find(tweet_id)
    rescue ActiveRecord::RecordNotFound
      begin
        t = rest.status(tweet_id)
        if t.is_a?(Twitter::Tweet) && (t.lang == 'ja' || t.lang == 'en')
          store_tweet(t, false)
          store_tweet_with_parent(t.in_reply_to_status_id) unless t.in_reply_to_status_id.nil?
        end
      rescue Twitter::Error::NotFound
        Rails.logger.info("Target Tweet #{tweet_id} Not found")
      rescue Twitter::Error::Forbidden
        Rails.logger.info("Forbidden to access Target Tweet #{tweet_id}")
      rescue Twitter::Error::Unauthorized
        Rails.logger.info('You have been blocked from the author of this tweet.')
      rescue Twitter::Error::ServiceUnavailable
        Rails.logger.info('Twitter Service Unavailable.')
      end
    end
  end

  def store_tweet(t, check)
    ActiveRecord::Base.connection_pool.with_connection do
      user = store_user(t.user)
      reply_check = true if check && (t.reply? || t.retweet?)
      #p t.reply?, t.retweet?, reply_check
      tweet = TweetText.find_or_create_by(id: t.id,
                                          text: t.full_text,
                                          favorite_count: t.favorite_count,
                                          in_reply_to_screen_name: t.in_reply_to_screen_name,
                                          in_reply_to_status_id: t.in_reply_to_status_id,
                                          in_reply_to_user_id: t.in_reply_to_user_id,
                                          lang: t.lang,
                                          retweet_count: t.retweet_count,
                                          source: t.source,
                                          created_at: t.created_at,
                                          deleted: false,
                                          reply: t.reply?,
                                          retweet: t.retweet?,
                                          retweet_id: t.retweeted_status.id,
                                          tweet_user_id: user.id,
                                          reply_check: reply_check
      )

      tweet.save!


      if t.geo.present?
        #p t.geo.coordinates[0], t.geo.coordinates[1], t.id
        #tweet.position = "MDSYS.ST_GEOMETRY(SDO_GEOMETRY(2001, 8307, SDO_POINT_TYPE(#{t.geo.coordinates[0]}, #{t.geo.coordinates[1]},NULL),NULL,NULL))"
        #tweet.position = "POINT(#{t.geo.coordinates[0]} #{t.geo.coordinates[1]})" if t.geo.present?
        tweet.insert_position(t.geo.coordinates[0], t.geo.coordinates[1])
      end


      t.hashtags.each do |h|
        hashtag = HashTag.find_or_create_by(tag: h.text)
        TweetsHashTag.find_or_create_by(tweet_text_id: tweet.id, hash_tag: hashtag)
      end
      t.urls.each do |u|
        url = Url.find_or_create_by(url: u.expanded_url.to_s)
        TweetsUrl.find_or_create_by(url: url, tweet_text_id: tweet.id)
      end

      t.media.each do |m|
        url = m.media_url_https.to_s
        Medium.find_or_create_by(tweet_text_id: tweet.id, filename: File.basename(url), url: url)
      end

      t.user_mentions.each do |m|
        UserMention.find_or_create_by(tweet_text_id: tweet.id, tweet_user_id: m.id)
      end


      tweet
    rescue ActiveRecord::NotNullViolation
      p 'not null violation'
    rescue ActiveRecord::RecordNotUnique
      p 'unique violation'
    ensure
      ActiveRecord::Base.connection.close
    end
  end

  def download_image(url, dir)
    filename = File.basename(url)
    path = "app/assets/images/#{dir}"
    FileUtils.mkdir_p(path) unless FileTest.exist?(path)
    begin
      open(url) do |image|
        File.open(Rails.root.join('app', 'assets', 'images', dir, filename), 'wb') do |f|
          f.puts image.read
        end
      end
    rescue OpenURI::HTTPError
      Rails.logger.info("Target Image #{url} Not found")
    rescue Net::ReadTimeout
      Rails.logger.info("Read Timeout")
      sleep(5.minutes)
    end
  end

  def create_user(user_id)
    store_user(rest.user(user_id))
  end

  def store_user(u)
    user = nil
    ActiveRecord::Base.transaction do
      begin
        user = TweetUser.find(u.id)
      rescue ActiveRecord::RecordNotFound
        user = TweetUser.new
      end
      user.id = u.id
      user.name = u.name
      user.screen_name = u.screen_name
      user.location = u.location
      user.url = u.url
      user.description = u.description
      user.verified = true if u.verified?
      user.followers_count = u.followers_count
      user.friends_count = u.friends_count
      user.listed_count = u.listed_count
      user.time_zone = u.time_zone
      user.lang = u.lang
      user.statuses_count = u.statuses_count
      user.utc_offset = u.utc_offset
      user.created_at = u.created_at
      user.save
    rescue ArgumentError
      p 'Argument Error, continue'
    rescue ActiveRecord::RecordNotUnique
      p 'violates unique constraint'
    end
    user
  end


  def streaming

    api = Rails.application.credentials.twitter_api


    Twitter::Streaming::Client.new do |config|
      config.consumer_key = api[:consumer_key]
      config.consumer_secret = api[:consumer_secret]
      config.access_token = api[:access_token]
      config.access_token_secret = api[:access_token_secret]
    end
  end

  def rest

    api = nil

    if Rails.env.production?
      api = Rails.application.credentials.twitter_api
    end

    api = Rails.application.credentials.twitter_api if Rails.env.test?
    api = Rails.application.credentials.twitter_api if Rails.env.development?
    Twitter::REST::Client.new do |config|
      config.consumer_key = api[:consumer_key]
      config.consumer_secret = api[:consumer_secret]
      config.access_token = api[:access_token]
      config.access_token_secret = api[:access_token_secret]
    end
  end

end