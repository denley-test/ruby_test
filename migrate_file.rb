#! /usr/bin/env ruby

require 'fileutils'
require_relative 'ruby_util'

def use_next?(is_test, action, source_file, target_file)
  if File.exist? target_file
    source_size, target_size = File.size(source_file), File.size(target_file)
    if source_size == target_size
      puts "  WARNING, existed #{source_file}, ignore" unless is_test
      return true
    else
      puts "  WARNING, existed #{source_file}, but #{source_size} > #{target_size}?, override" unless is_test
      File.delete(target_file) unless is_test
    end
  else
    puts "  #{action} #{source_file} ..."
  end
  return is_test
end

def migrate_file(is_test, condition, action, source_path, target_path)
  source_files = traverse(source_path, Regexp.new(condition, Regexp::IGNORECASE), %w(. .. .git tmp))
  target_files = source_files.map {|file| file.sub(source_path, target_path)}

  Hash[*source_files.zip(target_files).flatten].each_pair do|source_file, target_file|
    next if use_next?(is_test, action, source_file, target_file)
    target_path = File.dirname(target_file)
    FileUtils.makedirs(target_path) unless File.exist? target_path
    FileUtils.send(action, source_file, target_file)
  end
end

lambda {
	name_defaults = {"is_test":"true", "condition":"PartyServer.db$", "action":"copy", "source path":".", "target path":"./tmp" }
  is_test, condition, action, source_path, target_path = get_params(name_defaults)
  migrate_file(is_test.downcase.eql?("true"), condition, action.to_s, source_path, target_path)
  puts "Finished!"
  system("pause")
}.call