#! /usr/bin/env ruby

require 'fileutils'

lambda {
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

  def copy_files(source_files, target_files)
    Hash[*source_files.zip(target_files).flatten].each_pair do|source_file, target_file|
      next if File.exist? target_file
      target_path = File.dirname(target_file)
      FileUtils.makedirs(target_path)
      FileUtils.copy(source_file, target_file)
    end
  end

  condition, source_path, target_path = ARGV
  condition ||= '.db$'
  source_path ||= '.'
  target_path ||= './tmp'

  traverse(Regexp.new(condition, Regexp::IGNORECASE), source_path, %w(. .. .git tmp))
  target_files = source_files.map {|file| file.sub(source_path, target_path)}

  copy_files(source_files, target_files)
}.call