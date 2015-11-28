require 'nokogiri'
module Lita
  module Handlers
    class ZhihuDaily < Handler

      route(/zhihu/, :fetch_zhihu, command: true, help: {
        "zhihu" => "Display zhihu daily and monthly hot posts from zhihu.com"
      })

      def fetch_zhihu response
        posts = redis.get(key_of_today)
        posts = access_api unless posts
        response.reply posts
      end

      def key_of_today
        'zhihu_' + Time.now.strftime('%Y-%m-%d')
      end

      def access_api
        url = 'http://www.zhihu.com/explore'
        res = http.get url
        content = parse_data(res.body)
        redis.set(key_of_today, content) 
        content
      end

      def parse_data(html)
        posts = []
        doc = ::Nokogiri::HTML(html)
        doc.css('#js-explore-tab .question_link').each do |post|
          posts << "*#{post.text.strip}*: (http://www.zhihu.com/#{post[:href]})"
        end
        posts.join("\n")
      end

      Lita.register_handler(self)
    end
  end
end
