namespace :get_tweet do
  desc "twitterからデータを読み込むタスク"
  task twitter: :environment do
    GetTweet::Tweet.batch
  end

  task reply_tweet: :environment do
    GetTweet::Tweet.reply
  end
end
