#! /usr/bin/env ruby

require 'active_record'
require_relative 'get_params'

def execute_db(db_file)
  # get table names from db_name
  table_names = []
  ActiveRecord::Base.class_eval do
    establish_connection :adapter => "sqlite3",
                         :database => db_file
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
    model_name = table_name.sub(/^(?:dst|tbl)/, '').classify
    eval "#{model_name} = temp"
    puts "  #{model_name}"
  end
end

lambda {
  project_name, db_name = get_params(:project_name=>'jhgsxx', :db_name=>"PartyServer.db")
  db_file = "thirdresource/#{project_name}/projectdata/#{db_name}"
  execute_db(db_file)
}.call