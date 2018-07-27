namespace :get_tweet do
  desc "twitterからデータを読み込むタスク"
  task stream: :environment do
    GetTweet::Tweet.batch
  end

  task reply: :environment do
    GetTweet::Tweet.reply
  end
end
