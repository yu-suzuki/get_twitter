class Label < ApplicationRecord
  belongs_to :tweet_text
  belongs_to :label_option
end
