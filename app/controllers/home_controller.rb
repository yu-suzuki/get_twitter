class HomeController < ApplicationController
  def index
    @tweet_texts = TweetText.all
    @tweet_users = TweetUser.all
  end
end
