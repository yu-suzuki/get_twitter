class HomeController < ApplicationController
  def index
    @tweet_texts = TweetText.all
    @tweet_users = TweetUser.all

    recent_hash_tag_time = RecentHashTag.order(created_at: :desc).first.created_at
    recent_urls = RecentUrl.order(created_at: :desc).first.created_at

    @hash_tags = RecentHashTag.where(created_at: recent_hash_tag_time).includes(:hash_tag).all
    @urls = RecentUrl.where(created_at: recent_urls).includes(:url).all
  end

end
