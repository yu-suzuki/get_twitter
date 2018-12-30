class TweetText < ApplicationRecord
  has_many :tweet_users
  has_many :tweets_hash_tags
  has_many :tweets_urls
  has_many :hash_tags, through: :tweets_hash_tags
  has_many :urls, through: :tweets_urls
  has_many :labels

  def insert_position(lon, lat)
    sql = "update tweet_texts set position=SDO_GEOMETRY(2001,
             4326,
             SDO_POINT_TYPE(?, ?, NULL),
             NULL,
             NULL), longitude=?, latitude=? where id = ?"
    args = [sql, lon, lat, lon, lat, self.id]
    con = ActiveRecord::Base.send(:sanitize_sql_array, args)
    ActiveRecord::Base.connection.execute(con)
  end
end
