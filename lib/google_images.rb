require 'rest-client'
require 'yaml'

module BVG
  module GoogleImages
    extend ActiveSupport::Concern

    included do
      register_event :reply_with_image, :message_event, starting_with: image_regexp
      register_event :reply_with_unsafe_image, :message_event, starting_with: unsafe_image_regexp, in: '#tibbiesmut'

      load_yaml_parameters
    end

    module ClassMethods
      def load_yaml_parameters
        settings = YAML.load_file('bvg_bot.yml')
        @@google_api_key = settings['google_api_key']
        @@google_custom_search_id = settings['google_custom_search_id']
      end

      def image_regexp
        /\\(image|img)( \d+)? (.*)/i
      end

      def unsafe_image_regexp
        /\\(unsafe_image)( \d+)? (.*)/i
      end
    end

    def image_regexp
      self.class.image_regexp
    end

    def unsafe_image_regexp
      self.class.unsafe_image_regexp
    end

    def reply_with_image(event)
      respond_with_images(event)
    end

    def reply_with_unsafe_image(event)
      respond_with_images(event, false)
    end

    def respond_with_images(event, safe = true)
      results = images(event, {}, safe)
      images = []

      results_indexes(event, [results['searchInformation']['totalResults'].to_i, 100].max).each do |index|
        if results['queries']['request'].first['startIndex'] == (index / 10 * 10 + 1)
          images << results['items'][index % 10 - 1]
        else
          results = images(event, { startIndex: (index / 10 * 10 + 1) }, safe)
          images << results['items'][index % 10 - 1]
        end
      end
      images.each do |image|
        event.respond "#{image['link']}"
      end
    end

    def results_indexes(event, max_index)
      (number_of_images(event.message.content) || 1).to_i.times.map{|n| rand(max_index)}.uniq.sort
    end

    def google_images_uri
      URI.parse("https://www.googleapis.com/customsearch/v1")
    end

    def image_query(message, safe = true)
      safe ? image_regexp.match(message)[3] : unsafe_image_regexp.match(message)[3]
    rescue
      nil
    end

    def number_of_images(message, safe = true)
      safe ? image_regexp.match(message)[2] : unsafe_image_regexp.match(message)[2]
    rescue
      nil
    end

    def images(event, options = {}, safe = true)
      response = RestClient.get(google_images_uri.to_s, params: { key: @@google_api_key, cx: @@google_custom_search_id,
        q: image_query(event.message.content, safe), safe: safe ? 'medium' : 'off', searchType: 'image', count: 100 }.merge(options))

      JSON.parse(response)
    rescue
      event.respond "The Google Search Daily Quota has been exceeded"
    end

    def total_images_in_search(query, safe = true)
      images(query, safe)['searchInformation']['totalResults']
    rescue
      0
    end
  end
end
