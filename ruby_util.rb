#! /usr/bin/env ruby

def get_params(options = {})
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

def traverse(path, condition, ignore_path=%w(. ..))
  result = []
  if File.directory?(path)
    Dir.foreach(path) do | name |
      result.concat(traverse([path, name].join('/'), condition, ignore_path)) unless ignore_path.include? name
    end
  else
    result << path if condition =~ File.basename(path)
  end
  return result
end