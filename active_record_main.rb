#! /usr/bin/env ruby

require 'active_record'

lambda {
  table_names = []
  ActiveRecord::Base.class_eval do
    establish_connection :adapter => "sqlite3",
                         :database => "thirdsource/jhgsxx/projectdata/partyserver.db"
    self.pluralize_table_names = false
    table_names = connection.data_sources
  end

  table_names.each do |table_name|
    temp = Class.new(ActiveRecord::Base) do
      self.table_name = table_name
    end
    eval "#{table_name.gsub(/^(?:dst|tbl)/, '')} = temp"
  end
}.call