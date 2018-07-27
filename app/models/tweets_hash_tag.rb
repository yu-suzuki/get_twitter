class TweetsHashTag < ApplicationRecord
  belongs_to :hash_tag
  belongs_to :tweet_text
end
