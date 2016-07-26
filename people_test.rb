#! /usr/bin/env ruby
# use unittest

require 'test/unit'
require_relative 'people'

class TestPeople < Test::Unit::TestCase
  def setup
    @people = People.new
  end
  
  def test_name
  	assert_equal "Hello", @people.name
  end
end