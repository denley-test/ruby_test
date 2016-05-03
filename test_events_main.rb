#! /usr/bin/env ruby -w

class EventClass < BasicObject
  setups = []
  events = {}

  define_method :initialize do
    setups.clear
    events.clear
  end

  define_method :setup do |&block|
    setups << block
  end

  define_method :event do |name, &block|
    events[name] = block
  end

  define_method :each_setup do
    setups.each do |setup|
      setup.call
    end
  end

  define_method :each_event do |&block|
    events.each_pair do |name, event|
      block.call(name, event)
    end
  end
end

Dir.glob('*events.rb')  do | file |
  env = EventClass.new
  env.instance_eval do
    Kernel.eval File.read(file), Kernel.binding()
    each_setup
    each_event do |name, event|
      Kernel.puts "ALERT: #{name}" if event.call
    end
  end
end
