#! /usr/bin/env ruby

require 'fileutils'

def execute_backup(condition, action, source_path, target_path)
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

  def backup_files(action, source_files, target_files)
    Hash[*source_files.zip(target_files).flatten].each_pair do|source_file, target_file|
      if File.exist? target_file
        source_size, target_size = File.size(source_file), File.size(target_file)
        if source_size == target_size
          puts "  WARNING, existed #{source_file}, ignore"
          next
        else
          puts "  WARNING, existed #{source_file}, but #{source_size} > #{target_size}?, override"
          File.delete(target_file)
        end
      else
        puts "  #{action} #{source_file} ..."
      end
      target_path = File.dirname(target_file)
      FileUtils.makedirs(target_path) unless File.exist? target_path
      FileUtils.send(action, source_file, target_file)
    end
  end

  traverse(Regexp.new(condition, Regexp::IGNORECASE), source_path, %w(. .. .git tmp))
  target_files = source_files.map {|file| file.sub(source_path, target_path)}

  backup_files(action, source_files, target_files)
end

def get_params(options)
	def input_value(name, default)
		print "Enter #{name}(default is #{default}):"
		result = gets.chomp
		result = default if result.empty?
		result
	end
	
	def tranfer_value(index, default)
		ARGV.length > index ? ARGV[index] : default
	end
	
	if ARGV.empty?
		function, first_params = :input_value, options.keys
	else
		function, first_params = :tranfer_value, (0...options.size).to_a
	end
	
	result = []
	options.values.each_with_index do |default, index|
		result << send(function, first_params[index], default)
	end
	return result
end

lambda {
	name_defaults = {"condition":"PartyServer.db$", "action":"copy", "source path":".", "target path":"./tmp" }
  condition, action, source_path, target_path = get_params(name_defaults)
  execute_backup(condition, action.to_s, source_path, target_path)
  puts "Finished!"
  system("pause")
}.call