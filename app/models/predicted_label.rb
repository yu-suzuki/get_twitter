class PredictedLabel < ApplicationRecord
  belongs_to :classifier
  belongs_to :tweet_text
  belongs_to :label_option
end
