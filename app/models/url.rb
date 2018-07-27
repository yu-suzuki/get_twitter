class Url < ApplicationRecord
  has_many :tweets_urls
  has_many :tweet_texts, through: :tweets_urls
end
