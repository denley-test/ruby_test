class TemperatureSampler
  TEMP_TIMES = 4
  def initialize(sensor)
    @sensor = sensor
  end
 
  def average_temp
    (0...TEMP_TIMES).map { @sensor.read_temperature }.inject(0, &:+) / TEMP_TIMES.to_f
  end
end