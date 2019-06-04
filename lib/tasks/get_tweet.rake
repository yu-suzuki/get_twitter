namespace :get_tweet do
  desc "twitterからデータを読み込むタスク"
  task stream: :environment do
    GetTweet::Tweet.batch
  end

  task reply: :environment do
    GetTweet::Tweet.reply
  end

  task ranking: :environment do
    GetTweet::Tweet.ranking
  end

  task media: :environment do
    GetTweet::Tweet.media
  end

  task count: :environment do
    GetTweet::Tweet.count
  end

  task follower: :environment do
    GetTweet::Tweet.follower
  end

end
