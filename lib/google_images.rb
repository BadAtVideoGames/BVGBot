require 'rest-client'
require 'yaml'

module BVG
  module GoogleImages
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        register_class_event(Discordrb::Events::MessageEvent, containing: image_regexp, &method(:reply_with_image))
        register_class_event(Discordrb::Events::MessageEvent, containing: unsafe_image_regexp, in: '#tibbiesmut', &method(:reply_with_unsafe_image))
        load_yaml_parameters
      end
    end

    module ClassMethods
      def load_yaml_parameters
        settings = YAML.load_file('bvg_bot.yml')
        @@google_api_key = settings['google_api_key']
        @@google_custom_search_id = settings['google_custom_search_id']
      end

      def reply_with_image(event)
        respond_with_image(event, images(image_query(event.message.content)))
      end

      def reply_with_unsafe_image(event)
        respond_with_image(event, images(image_query(event.message.content, false), false))
      end

      def respond_with_image(event, response_hash)
        if response_hash['searchInformation']['totalResults'].to_i > 0
          image = response_hash['items'][rand(response_hash['items'].count)]
          event.respond "#{image['link']}"
        end
      end

      def google_images_uri
        URI.parse("https://www.googleapis.com/customsearch/v1")
      end

      def image_query(message, safe = true)
        safe ? image_regexp.match(message)[2] : unsafe_image_regexp.match(message)[2]
      rescue
        nil
      end

      def image_regexp
        /\\(image|img) (.*)/i
      end

      def unsafe_image_regexp
        /\\(unsafe_image) (.*)/i
      end

      def images(query, safe = true)
        response = RestClient.get(google_images_uri.to_s, params: { key: @@google_api_key, cx: @@google_custom_search_id,
          q: query, safe: safe ? 'medium' : 'off', searchType: 'image' })

        JSON.parse(response)
      rescue
        []
      end
    end
  end
end
