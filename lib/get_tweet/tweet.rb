# frozen_string_literal: true

require 'twitter'

module GetTweet::Tweet
  module_function

  def batch
    loop do
      streaming.sample do |t|
        store_tweet(t, true) if t.is_a?(Twitter::Tweet) && (t.lang == 'ja')
        check_tweet(t) if t.is_a?(Twitter::Streaming::DeletedTweet)
      end
    end
  end

  def reply
    loop do
      tweets = TweetText.where(reply_check: true)
      if tweets.count.positive?
        tweets.each do |t|
          store_tweet_with_parent(t.in_reply_to_status_id) if t.reply?
          store_tweet_with_parent(t.retweet_id) if t.retweet?
          t.reply_check = false
          t.save
        rescue Twitter::Error::TooManyRequests
          p 'too many requests, sleep 14 minutes'
          sleep(14.minutes)
        end
      else
        p 'no tweet to get, sleep 5 minutes'
        sleep(5.minutes)
      end
    end
  end

  def check_tweet(tweet)
    tweet = TweetText.find_by_tweet_id(tweet.id)
    if tweet.present?
      tweet.deleted = true
      tweet.save
    end
  end

  def store_tweet_with_parent(tweet_id)
    if TweetText.find_by_tweet_id(tweet_id).nil?
      t = rest.status(tweet_id)
      if t.is_a?(Twitter::Tweet) && (t.lang == 'ja')
        store_tweet(t, false)
        store_tweet_with_parent(t.in_reply_to_status_id) unless t.in_reply_to_status_id.nil?
      end
    else
      p 'already get'
    end
  rescue Twitter::Error::NotFound
    p 'Not found'
  rescue Twitter::Error::Forbidden
    p 'Forbidden'

  end

  def store_tweet(t, check)
    ActiveRecord::Base.transaction do
      tweet = TweetText.find_by_tweet_id(t.id)
      tweet = TweetText.new if tweet.nil?
      tweet.text = t.full_text
      tweet.tweet_id = t.id
      tweet.favorite_count = t.favorite_count
      tweet.in_reply_to_screen_name = t.in_reply_to_screen_name
      tweet.in_reply_to_status_id = t.in_reply_to_status_id
      tweet.in_reply_to_user_id = t.in_reply_to_user_id
      tweet.lang = t.lang
      tweet.retweet_count = t.retweet_count
      tweet.source = t.source
      tweet.created_at = t.created_at
      tweet.deleted = false
      tweet.reply = t.reply?
      tweet.retweet = t.retweet?
      tweet.reply_check = true if check && (t.reply? || t.retweet?)
      tweet.retweet_id = t.retweeted_status.id
      tweet.position = "POINT(#{t.geo.coordinates[0]} #{t.geo.coordinates[1]})" if t.geo.present?
      user = store_user(t.user)
      tweet.tweet_user_id = user.user_id
      tweet.save
      tweet
    end
  end

  def store_user u
    ActiveRecord::Base.transaction do
      user = TweetUser.find_by_user_id(u.id)
      user = TweetUser.new if user.nil?
      user.id = u.id
      user.name = u.name
      user.email = u.email
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
      user
    end
  end

  def streaming
    Twitter::Streaming::Client.new do |config|
      config.consumer_key = Rails.application.credentials.twitter_api[:consumer_key]
      config.consumer_secret = Rails.application.credentials.twitter_api[:consumer_secret]
      config.access_token = Rails.application.credentials.twitter_api[:access_token]
      config.access_token_secret = Rails.application.credentials.twitter_api[:access_token_secret]
    end
  end

  def rest
    Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.credentials.twitter_api[:consumer_key]
      config.consumer_secret = Rails.application.credentials.twitter_api[:consumer_secret]
      config.access_token = Rails.application.credentials.twitter_api[:access_token]
      config.access_token_secret = Rails.application.credentials.twitter_api[:access_token_secret]
    end
  end
end