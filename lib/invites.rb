module BVG
  module Invites
    extend ActiveSupport::Concern

    included do
      register_event :respond_to_join_command, :mention_event, containing: 'join'
      register_event :respond_to_join_command, :private_message_event, containing: 'join'
    end

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
