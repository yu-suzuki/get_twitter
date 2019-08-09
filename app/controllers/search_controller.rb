class SearchController < ApplicationController
  def search
    keywords = search_params[:keyword]
    lang = search_params[:lang]
    deleted = search_params[:deleted]
    mention = search_params[:mention]
    retweet = search_params[:retweet]
    reply = search_params[:reply]
    data = nil
    query = ""
    keywords.split(',').each do |k|
      query << k
      query << " OR "
    end

    query.slice!(-4,4)
    data = TweetText.where("text &@~ ?", query)
    data = data.where(lang: lang) if lang && data
    data = data.where(deleted: deleted) if deleted && data
    data = data.where(mention: mention) if mention && data
    data = data.where(retweet: retweet) if retweet && data
    data = data.where(reply: reply) if reply && data
    data = data.order(id: :desc).limit(1000)
    render json: {status: 'SUCCESS', count: data.size, query: query,  data: data}
  end

  def search_params
    params.permit(:keyword, :lang, :deleted, :mention, :retweet, :reply)
  end
end
