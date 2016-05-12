#! /usr/bin/env ruby

require 'fileutils'
require_relative 'get_params'

def execute_backup(is_test, condition, action, source_path, target_path)
  source_files = []
  define_method :traverse do |condition, path, ignore_path=%w(. ..)|
    if File.directory?(path)
      Dir.foreach(path) do | name |
        traverse(condition, [path, name].join('/'), ignore_path) unless ignore_path.include? name
      end
    else
      source_files << path if condition =~ File.basename(path)
    end
  end

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

  def backup_files(is_test, action, source_files, target_files)
    Hash[*source_files.zip(target_files).flatten].each_pair do|source_file, target_file|
      next if use_next?(is_test, action, source_file, target_file)
      target_path = File.dirname(target_file)
      FileUtils.makedirs(target_path) unless File.exist? target_path
      FileUtils.send(action, source_file, target_file)
    end
  end

  traverse(Regexp.new(condition, Regexp::IGNORECASE), source_path, %w(. .. .git tmp))
  target_files = source_files.map {|file| file.sub(source_path, target_path)}

  backup_files(is_test, action, source_files, target_files)
end

lambda {
	name_defaults = {"is_test":"true", "condition":"PartyServer.db$", "action":"copy", "source path":".", "target path":"./tmp" }
  is_test, condition, action, source_path, target_path = get_params(name_defaults)
  execute_backup(is_test.downcase.eql?("true"), condition, action.to_s, source_path, target_path)
  puts "Finished!"
  system("pause")
}.call