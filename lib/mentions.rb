module BVG
  module Mentions
    extend ActiveSupport::Concern

    included do
      register_event :reply_with_fuck_you_too_q, :mention_event, containing: /(f|F)(uck)? you/
    end

    def reply_with_fuck_you_too_q(event)
      event.respond "#{event.user.mention} Fuck you too #{event.author.username}!"
    end
  end
end
