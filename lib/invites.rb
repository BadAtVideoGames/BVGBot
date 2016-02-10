module BVG
  module Invites
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        register_class_event(Discordrb::Events::MentionEvent, containing: 'join', &method(:respond_to_join_command))
        register_class_event(Discordrb::Events::PrivateMessageEvent, containing: 'join', &method(:respond_to_join_command))
      end
    end

    module ClassMethods
      def respond_to_join_command(event)
        instance.join(invite_link(event)) if join_command?(event)
      end

      def message_without_mention(message)
        message.dup.tap{|m| m.slice!(instance.bot_user.mention) }.lstrip
      end

      def join_command?(event)
        Discordrb::LOGGER.warn "Join Command? #{message_without_mention(event.message.content).start_with? 'join'}"
        message_without_mention(event.message.content).start_with? 'join'
      end

      def invite_link(event)
        message_without_mention(event.message.content).tap{|m| m.slice!('join') }.lstrip.chomp
      end
    end
  end
end
