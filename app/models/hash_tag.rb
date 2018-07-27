class HashTag < ApplicationRecord
  has_many :tweets_hash_tags
  has_many :tweet_texts, through: :tweets_hash_tags
end
