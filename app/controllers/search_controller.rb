class SearchController < ApplicationController
  def search
    keywords = search_params[:keyword]
    lang = search_params[:lang]
    deleted = search_params[:deleted]
    retweet = search_params[:retweet]
    reply = search_params[:reply]
    id_max = search_params[:id_max]
    id_min = search_params[:id_min]

    query = ""

    begin
      keywords.split(',').each do |k|
        query << k
        query << " "
      end

      query.slice!(-1, 1)
      data = TweetText.all
      data = data.where("text &@~ ?", query)
      data = data.where(lang: lang) if lang && data
      data = data.where(deleted: deleted) if deleted && data
      data = data.where(retweet: retweet) if retweet && data
      data = data.where(reply: reply) if reply && data
      data = data.where("id > ?", id_min) if id_min && data
      data = data.where("id < ?", id_max) if id_max && data
      data = data.order(id: :asc).limit(100)
      if data.empty?
        render json: {status: 'ERROR', message: 'Not found', query: query}
      else
        render json: {status: 'SUCCESS', count: data.size, query: query,
                      id_max: data.first.id, id_min: data.last.id, data: data.select(:id,:tweet_user_id, :text, :created_at)}
      end
    rescue NoMethodError => e
      render json: {status: 'ERROR', message: e}
    end

  end

  def search_params
    params.permit(:keyword, :lang, :deleted, :retweet, :reply, :id_min, :id_max)
  end
end
