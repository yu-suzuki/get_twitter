class SearchController < ApplicationController
  def search
    keywords = params[:keyword]
    lang = params[:lang]
    deleted = params[:deleted]
    mention = params[:mention]
    retweet = params[:retweet]
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
    data = data.order(id: :desc).limit(1000)
    render json: {status: 'SUCCESS', count: data.size, query: query,  data: data}
  end

  def search_params
    params.require(:keyword).permit(:lang, :deleted, :mention, :retweet)
  end
end
