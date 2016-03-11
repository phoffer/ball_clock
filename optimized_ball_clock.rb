# frozen_string_literal: true
# Paul Hoffer
# Note: this assumes the fixed ball in the hour indicator was not selected from the total ball count
# If it was selected from the ball count, then the minimum number (27) must be incremented, the overflow (11) must be incremented, and the hour indicator is not completely flushed on meridian change

unless defined? BallCountError
  class BallCountError < StandardError
    attr_reader :message
    def initialize
      @message = 'Please enter a ball count from 27 to 127 (inclusive)'
    end
  end
end

class OptimizedClock
  MIN_COUNT = 27
  MAX_COUNT = 127
  attr_reader :queue, :time, :minute_queue, :five_queue, :hour_queue
  def initialize(count: 0, time: nil)
    raise BallCountError unless (MIN_COUNT..MAX_COUNT).cover? count
    @count        = count
    @minute       = parse_time(time)
    @current      = 0
    @minute_queue = []
    @five_queue   = []
    @hour_queue   = []
    @meridian     = 0
    @number_arr   = (1..count).to_a
    @queue        = @number_arr.dup
    @minute.zero? ? circulate : set!
  end
  def time
    Time.at(@current * 60).utc.strftime('%-l:%M')
  end
  def status
    {
      'Min'     => minute_queue_numbers,
      'FiveMin' => five_queue_numbers,
      'Hour'    => hour_queue_numbers,
      'Main'    => queue_numbers,
      # 'Time'    => time
    }
  end
  def minute_queue_numbers
    @minute_queue
  end
  def five_queue_numbers
    @five_queue
  end
  def hour_queue_numbers
    @hour_queue
  end
  def queue_numbers
    @queue
  end
  def days
    @meridian / 2
  end
  private
  def parse_time(time)
    return 0 unless time
    return time if Numeric === time
    h, m, _ = time.split(':')
    h.to_i * 60 + m.to_i
  end
  def set!
    tick! until @current == @minute
  end
  def circulate
    tick!
    tick! until @queue == @number_arr
  end
  def tick!
    next_ball = @queue.shift
    @current += 1
    if @minute_queue.size == 4
      advance_five(next_ball)
    else
      @minute_queue << next_ball
    end
  end
  def advance_five(next_ball)
    # advance the five
    @queue.concat(@minute_queue.reverse)
    @minute_queue.clear
    if @five_queue.size == 11
      advance_hour(next_ball)
    else
      @five_queue << next_ball
    end
  end
  def advance_hour(next_ball)
    # advance the hour
    @queue.concat(@five_queue.reverse)
    @five_queue.clear
    if @hour_queue.size == 11
      advance_meridian(next_ball)
    else
      @hour_queue << next_ball
    end
  end
  def advance_meridian(next_ball)
    # advance the meridian
    @queue.concat(@hour_queue.reverse) << next_ball
    @hour_queue.clear
    @meridian += 1
    @current = 0
  end
end

if __FILE__ == $0
  puts Clock.new(count: 30, time: 325).status
  puts Clock.new(count: 30).days
  puts Clock.new(count: 45).days
end