module BVG
  module FuckYouSteve
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        register_class_event(Discordrb::Events::MessageEvent, containing: fuck_you_steve_regex, &method(:reply_with_fuck_you_too_q))
      end
    end

    module ClassMethods
      def reply_with_fuck_you_too_q(event)
        event.respond "#{event.user.mention} Steve says, 'Fuck you too Q!'"
      end

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
  end
end
