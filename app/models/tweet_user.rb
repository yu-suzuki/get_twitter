class TweetUser < ApplicationRecord
  has_many :tweet_texts
end
