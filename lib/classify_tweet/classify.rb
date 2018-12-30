module ClassifyTweet::Classify
  module_function

  def make_model
    require 'natto'
    require 'open3'
    time = Time.now.to_i.to_s
    train_filename = 'train_' + time + ".txt"
    nm = Natto::MeCab.new
    f = File.open('./classifier/training/' + train_filename, 'w')
    Label.all.group(:tweet_text_id).select(:tweet_text_id).each do |l|
      t = l.tweet_text
      labels = ""
      t.labels.each do |label|
        labels += "__label__" + label.label_option.name.gsub(' ', '_') + " "
      end
      text = ''
      nm.parse(t.text) do |n|
        #next unless n.feature.match(/名詞/)
        #next if n.feature.match(/(非自立|数|代名詞)/)
        #next if n.surface.match(/\./)
        text += n.surface
        text += " "
      end
      line = labels + text
      f.puts line
    end
    f.close
    model_filename = 'model_' + time
    system('fasttext supervised -input ./classifier/training/' + train_filename + ' -output ./classifier/model/' + model_filename)

  end
end