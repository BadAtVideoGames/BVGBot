module BVG
  module FuckYouSteve
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        register_class_event(Discordrb::Events::MessageEvent, containing: /(f|F)(uck)? you.*?(s|S)teve/, &method(:reply_with_fuck_you_too_q))
      end
    end

    module ClassMethods
      def reply_with_fuck_you_too_q(event)
        event.respond "Steve says, 'Fuck you too #{event.author.username}!'"
      end
    end
  end
end
