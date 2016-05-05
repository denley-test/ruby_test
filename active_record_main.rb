#! /usr/bin/env ruby

require 'active_record'


lambda {
  # assign db_name
  puts "Enter current db name(default is party):"
  db_name = gets.chomp
  db_name = 'party' if db_name.empty?

  # get table names from db_name
  table_names = []
  ActiveRecord::Base.class_eval do
    establish_connection :adapter => "sqlite3",
                         :database => "thirdresource/jhgsxx/projectdata/#{db_name}server.db"
    self.pluralize_table_names = false
    table_names = connection.data_sources
  end

  # generate class through table_name
  table_names.each do |table_name|
    temp = Class.new(ActiveRecord::Base) do
      self.table_name = table_name
      self.primary_key = :id
      validates_uniqueness_of :id
    end
    eval "#{table_name.gsub(/^(?:dst|tbl)/, '')} = temp"
  end
}.call