#! /usr/bin/env ruby
# use flexmock

require 'minitest/autorun'
require 'flexmock/test_unit'
require_relative 'temperature_sampler'

class TestTemperatureSampler < Minitest::Test
  def test_sensor_can_average
    sensor = FlexMock.new("temp")
	  sensor.should_receive(:read_temperature).times(TemperatureSampler::TEMP_TIMES).and_return(10, 13, 19, 14)
	
	  sampler = TemperatureSampler.new(sensor)
	  assert_in_delta 14, sampler.average_temp, 0.01
  end
end