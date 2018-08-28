require 'csv'

class HomeController < ApplicationController
  def index
    @tweet_texts = TweetText.all
    @tweet_users = TweetUser.all
    @media = Medium.all

    recent_hash_tag_time = RecentHashTag.order(created_at: :desc).first.created_at
    recent_urls = RecentUrl.order(created_at: :desc).first.created_at

    @hash_tags = RecentHashTag.where(created_at: recent_hash_tag_time).includes(:hash_tag).all
    @urls = RecentUrl.where(created_at: recent_urls).includes(:url).all
  end

  def insert_tweet
    rest = GetTweet::Tweet.rest
    CSV.foreach(file_params[:file].path, headers: false, encoding: 'utf-8') do |r|
      begin
        tweet_id = r[1]
        unless TweetText.exists?(tweet_id)
          t = rest.status(tweet_id)
          GetTweet::Tweet.store_tweet_with_parent(t)
        end
      rescue Twitter::Error::NotFound
        Rails.logger.info("Target Tweet #{tweet_id} Not found")
      rescue Twitter::Error::Forbidden
        Rails.logger.info("Forbidden to access Target Tweet #{tweet_id}")
      rescue Twitter::Error::Unauthorized
        Rails.logger.info('You have been blocked from the author of this tweet.')
      rescue Twitter::Error::ServiceUnavailable
        Rails.logger.info('Twitter Service Unavailable.')
      rescue ActiveRecord::StatementInvalid
        p 'postgres error, reconnect'
        ActiveRecord::Base.connection.reconnect!
      rescue Twitter::Error::TooManyRequests => error
        weight_time = error.rate_limit.reset_in + 1
        p 'too many requests, sleep ' + weight_time.to_s
        sleep(weight_time.seconds)
      end
    end
  end

  private

  def file_params
    params.permit(:file)
  end

end
