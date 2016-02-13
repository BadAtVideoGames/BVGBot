module BVG
  module FuckYouSteve
    extend ActiveSupport::Concern

    included do
      register_event :reply_with_fuck_you_too_q, :message_event, containing: fuck_you_steve_regex
    end

    module ClassMethods
      def fuck_you_steve_regex
        /\b(#{curse_words})\b#{space_and_punctuation}*?\b(#{you_words})\b#{space_and_punctuation}*?\b(#{steve_names})\b/i
      end

      def curse_words
        %w[fuck fuq f fudge fug].join("|")
      end

      def you_words
        %w[you u yu yoo].join("|")
      end

      def steve_names
        %w[steve steeve steev stev ste stevia].join("|")
      end

      def space_and_punctuation
        "[\\W_-]"
      end
    end

    def reply_with_fuck_you_too_q(event)
      event.respond "#{event.user.mention} Steve says, 'Fuck you too Q!'"
    end
  end
end
