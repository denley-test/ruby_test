#! /usr/bin/env ruby

require 'active_record'
require_relative 'ruby_util'

class ActiveRecord::Base
  def self.init(table_name, primary_key, db_config)
    establish_connection db_config
    self.pluralize_table_names = false
    self.table_name = table_name
    self.primary_key = primary_key
  end
end

class SourceTable < ActiveRecord::Base; end
class TargetTable < ActiveRecord::Base; end

def get_target_record(project_name, source_record, attributes)
  result = {}
  attributes.each_pair do |key, value|
    result[value] = key.eql?(:Note)? project_name : source_record.send(key)
  end
  return result
end

def get_project_name(start_path, db_file)
  result = db_file.dup
  result.sub! Regexp.new("#{start_path}/"), ''
  result.sub! /\/projectdata\/.*/, ''
  return result
end

def get_unique_value(source, target, project_name)
  result = source.dup
  while target.exists?(result)
    result << "_#{project_name}"
  end
  result
end

lambda {
  attributes = {:RoadSN=>:sn, :name=>:name, :RoadLevel=>:level, :StartStake=>:start_stake, :EndStake=>:end_stake, :Note=>:note}
  start_path = 'thirdresource'
  db_files = traverse(start_path, Regexp.new('DataServer.db$', Regexp::IGNORECASE))
  TargetTable.init("routes", :sn, :adapter => "sqlite3", :database => "../JustWay/db/development.sqlite3")
  count = 0
  db_files.each do |db_file|
    SourceTable.init("tblRoute", :id, :adapter => "sqlite3", :database => db_file)
    project_name = get_project_name(start_path, db_file)
    records = SourceTable.select(attributes.keys)
    count += records.size
    puts "#{db_file}: #{count}"
    records.each_with_index do |record|
      new_record = get_target_record(project_name, record, attributes)
      new_record[:sn] = get_unique_value(new_record[:sn], TargetTable, project_name)
      TargetTable.create(new_record)
    end
  end
  puts count
}.call