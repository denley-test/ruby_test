#! /usr/bin/env ruby

require 'active_support'
$LOAD_PATH.unshift File.expand_path('..', __FILE__)

module MyModule
  extend ActiveSupport::Autoload

  autoload :MyClass, 'my_class'
  eager_autoload do
    autoload :MyCache, 'my_cache'
  end
end

puts "main is starting ..."
MyModule::eager_load!
MyModule::MyClass

puts "under no output"
MyModule::MyCache.new


puts "main is end"