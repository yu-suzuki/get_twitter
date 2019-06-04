class Follow < ApplicationRecord
  belongs_to :from_user, class_name: 'TweetUser'
  belongs_to :to_user, class_name: 'TweetUser'
end
