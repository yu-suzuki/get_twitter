class UserMention < ApplicationRecord
  belongs_to :tweet_text
  belongs_to :tweet_user
end
