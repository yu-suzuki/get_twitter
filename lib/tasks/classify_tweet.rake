namespace :classify_tweet do
  desc "twitterのデータを分類するタスク"
  task make_model: :environment do
    ClassifyTweet::Classify.make_model
  end
end
