require 'discordrb'
require 'active_support/inflector'
require 'active_support/core_ext/string'

module BVG
  class ModularBot < Discordrb::Bot
    @@modular_bot = nil
    @@modular_bot__mutex__ = Mutex.new

    def initialize(email, password, debug = false)
      super
      puts "Initializing"
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

    def reply_with_pong(event)
      event.respond 'Pong!'
    end

    def self.class_registered_events
      @@class_registered_events ||= []
    end

    def self.register_event(*args, &block)
      proc = block_given? ? block : args.shift.to_sym

      add_event_to_class_events(*args, proc)
    end

    def self.add_event_to_class_events(*args, block)
      class_registered_events << [*args, block]
    end

    def register_class_events
      self.class.class_registered_events.each do |event_params|
        proc = event_params.pop

        register_event(proc, *event_params)
      end
    end

    alias_method :discordrb_register_event, :register_event
    def register_event(proc, *args)
      event_type = event_type_klass(args.shift)
      return if event_type.nil?

      proc = method(proc) unless proc.is_a? Proc

      discordrb_register_event(event_type, *args, proc)
    end

    def event_type_klass(event_type)
      "Discordrb::Events::#{event_type.to_s.camelize}".constantize
    rescue
      nil
    end

    register_event :reply_with_pong, :message_event, with_text: 'Ping!'
  end
end
