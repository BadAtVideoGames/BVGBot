module BVG
  module Mentions
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        register_class_event(Discordrb::Events::MentionEvent, containing: /(f|F)(uck)? you/, &method(:reply_with_fuck_you_too_q))
      end
    end

    module ClassMethods
      def reply_with_fuck_you_too_q(event)
        event.respond "Fuck you too #{event.author.username}!"
      end
    end
  end
end
