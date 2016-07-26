#! /usr/bin/env ruby
# use minitest

require 'minitest/autorun'
require_relative 'people'

class TestPeople < Minitest::Test
  def setup
    @people = People.new
  end
  
  def test_name
  	assert_equal "Hello", @people.name
  end
end