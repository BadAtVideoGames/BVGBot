require 'discordrb'

module BVG
  class ModularBot < Discordrb::Bot
    @@modular_bot = nil
    @@modular_bot__mutex__ = Mutex.new

    def initialize(email, password, debug = false)
      super
      register_class_events
    end

    # Singletonize this class
    def self.instance(email=nil, password=nil, debug = false)
      return @@modular_bot if @@modular_bot
      @@modular_bot__mutex__.synchronize {
        return @@modular_bot if @@modular_bot
        @@modular_bot = new(email, password, debug)
      }
      @@modular_bot
    end

    private

    def email
      @email
    end

    def password
      @password
    end

    def email=(value)
      @email = value
    end

    def password=(value)
      @password = value
    end

    private_class_method :new

    def self.class_registered_events
      @@class_registered_events ||= []
    end

    def self.register_class_event(event_klass, attributes={}, &block)
      class_registered_events << [event_klass, attributes, block]
    end

    def self.reply_with_pong(event)
      puts "Replying to Ping!"
      event.respond 'Pong!'
    end

    register_class_event(MessageEvent, {with_text: 'Ping!'}, &method(:reply_with_pong))

    def register_class_events
      self.class.class_registered_events.each do |event_params|
        register_event(*event_params)
      end
    end
  end
end
