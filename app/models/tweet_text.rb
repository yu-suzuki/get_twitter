class TweetText < ApplicationRecord
  has_many :tweet_users
  has_many :tweets_hash_tags
  has_many :tweets_urls
  has_many :hash_tags, through: :tweets_hash_tags
  has_many :urls, through: :tweets_urls
end
