class TweetsUrl < ApplicationRecord
  belongs_to :tweet_text
  belongs_to :url
end
